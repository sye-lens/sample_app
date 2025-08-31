require "active_support/inflector"

def existing(paths)
  Array(paths).select { |p| File.exist?(p) }
end

guard :minitest, all_on_start: false, spring: false, cmd: "bin/rails test" do
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch('test/test_helper.rb') { 'test' }

  watch('config/routes.rb') { existing(integration_tests) }
  watch(%r{app/views/layouts/.*}) { existing(integration_tests) }

  watch(%r{^app/models/(.*?)\.rb$}) do |m|
    existing([
      "test/models/#{m[1]}_test.rb",
      "test/integration/microposts_interface_test.rb"
    ])
  end

  watch(%r{^test/fixtures/(.*?)\.yml$}) do |m|
    existing("test/models/#{m[1].singularize}_test.rb")
  end

  watch(%r{^app/mailers/(.*?)\.rb$})     { |m| existing("test/mailers/#{m[1]}_test.rb") }
  watch(%r{^app/views/(.*)_mailer/})     { |m| existing("test/mailers/#{m[1]}_mailer_test.rb") }

  watch(%r{^app/controllers/(.*?)_controller\.rb$}) { |m| existing(resource_tests(m[1])) }

  watch(%r{^app/views/([^/]*?)/.*\.html\.erb$}) do |m|
    existing(["test/controllers/#{m[1]}_controller_test.rb"] + integration_tests(m[1]))
  end

  watch(%r{^app/helpers/(.*?)_helper\.rb$}) { |m| existing(integration_tests(m[1])) }

  watch('app/views/layouts/application.html.erb') { existing('test/integration/site_layout_test.rb') }
  watch('app/helpers/sessions_helper.rb')         { existing(integration_tests << 'test/helpers/sessions_helper_test.rb') }

  watch('app/controllers/sessions_controller.rb') do
    existing(['test/controllers/sessions_controller_test.rb',
              'test/integration/users_login_test.rb'])
  end

  watch('app/controllers/account_activations_controller.rb') { existing('test/integration/users_signup_test.rb') }

  watch(%r{app/views/users/.*}) do
    existing(resource_tests('users') + ['test/integration/microposts_interface_test.rb'])
  end

  watch('app/controllers/relationships_controller.rb') do
    existing(['test/controllers/relationships_controller_test.rb',
              'test/integration/following_test.rb'])
  end
end

def integration_tests(resource = :all)
  resource == :all ? Dir['test/integration/*'] : Dir["test/integration/#{resource}_*.rb"]
end

def interface_tests
  integration_tests << 'test/controllers'
end

def controller_test(resource)
  "test/controllers/#{resource}_controller_test.rb"
end

def resource_tests(resource)
  integration_tests(resource) << controller_test(resource)
end