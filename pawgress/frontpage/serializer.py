from django.conf import settings
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.urls import reverse
from django.utils.encoding import DjangoUnicodeDecodeError, force_bytes, smart_str
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from rest_framework import serializers

from frontpage.models import User
from frontpage.utils import Util


class UserRegistrationSerializer(serializers.ModelSerializer):
  password2 = serializers.CharField(style={'input_type':'password'}, write_only=True)

  class Meta:
    model = User
    fields = ['email', 'name', 'password', 'password2', 'tc']
    extra_kwargs = {
      'password': {'write_only': True}
    }

  def validate(self, attrs):
    password = attrs.get('password')
    password2 = attrs.get('password2')
    if password != password2:
      raise serializers.ValidationError("Password and Confirm Password doesn't match")
    return attrs

  def create(self, validated_data):
    return User.objects.create_user(**validated_data)


class UserLoginSerializer(serializers.ModelSerializer):
  email = serializers.EmailField(max_length=255)

  class Meta:
    model = User
    fields = ['email', 'password']
    extra_kwargs = {
      'password': {'write_only': True}
    }


class UserProfileSerializer(serializers.ModelSerializer):
  class Meta:
    model = User
    fields = ['id', 'email', 'name']


class UserChangePasswordSerializer(serializers.Serializer):
  password = serializers.CharField(max_length=255, style={'input_type':'password'}, write_only=True)
  password2 = serializers.CharField(max_length=255, style={'input_type':'password'}, write_only=True)

  class Meta:
    fields = ['password', 'password2']

  def validate(self, attrs):
    password = attrs.get('password')
    password2 = attrs.get('password2')
    user = self.context.get('user')
    if password != password2:
      raise serializers.ValidationError("Password and Confirm Password doesn't match")
    user.set_password(password)
    user.save()
    return attrs


class SendPasswordResetEmailSerializer(serializers.Serializer):
  email = serializers.EmailField(max_length=255)

  class Meta:
    fields = ['email']

  def _build_reset_link(self, uid, token):
    template = settings.PASSWORD_RESET_URL_TEMPLATE
    if template:
      return template.format(uid=uid, token=token)

    request = self.context.get('request')
    if request is None:
      raise serializers.ValidationError('Password reset URL is not configured')

    reset_path = reverse('reset-password', kwargs={'uid': uid, 'token': token})
    return request.build_absolute_uri(reset_path)

  def validate(self, attrs):
    email = attrs.get('email')
    user = User.objects.filter(email=email).first()
    if user is None:
      return attrs

    uid = urlsafe_base64_encode(force_bytes(user.id))
    token = PasswordResetTokenGenerator().make_token(user)
    link = self._build_reset_link(uid, token)
    body = 'Click the following link to reset your password: ' + link
    data = {
      'subject': 'Reset Your Password',
      'body': body,
      'to_email': user.email
    }
    Util.send_email(data)
    return attrs


class UserPasswordResetSerializer(serializers.Serializer):
  password = serializers.CharField(max_length=255, style={'input_type':'password'}, write_only=True)
  password2 = serializers.CharField(max_length=255, style={'input_type':'password'}, write_only=True)

  class Meta:
    fields = ['password', 'password2']

  def validate(self, attrs):
    try:
      password = attrs.get('password')
      password2 = attrs.get('password2')
      uid = self.context.get('uid')
      token = self.context.get('token')
      if password != password2:
        raise serializers.ValidationError("Password and Confirm Password doesn't match")
      user_id = smart_str(urlsafe_base64_decode(uid))
      user = User.objects.get(id=user_id)
      if not PasswordResetTokenGenerator().check_token(user, token):
        raise serializers.ValidationError('Token is not Valid or Expired')
      user.set_password(password)
      user.save()
      return attrs
    except DjangoUnicodeDecodeError:
      raise serializers.ValidationError('Token is not Valid or Expired')
