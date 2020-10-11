# frozen_string_literal: true

User.create(
  login: 'admin',
  email: 'admin@localhost',
  email_confirmation: 'admin@localhost',
  password: 'changeme',
  password_confirmation: 'changeme'
)