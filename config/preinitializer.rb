require "yaml"

env = if defined?(Rake.application) && Rake.application.top_level_tasks.grep(/^(default$|test(:|$))/).any?
        "test"
      else
        ENV["RAILS_ENV"] || "development"
      end

config = YAML.load_file(File.expand_path(env == "test" ? "../example.application.yml" : "../application.yml", __FILE__))

apeiara_env_vars = []
["STAGING", "SPDL", "UK"].each do |account|
  apeiara_env_vars.push("ALM_#{account}_AUTH_ID",
                        "ALM_#{account}_AUTH_SECRET")
end

ENV.each do |key, value|
  Object.const_set(Regexp.last_match(1).upcase, value) if key =~ /^OSM_(.*)$/

  if apeiara_env_vars.include?(key)
    Object.const_set(key.upcase, value)
  end
end

config[env].each do |key, value|
  Object.const_set(key.upcase, value) unless Object.const_defined?(key.upcase)
end
