require "yaml"

env = if defined?(Rake.application) && Rake.application.top_level_tasks.grep(/^(default$|test(:|$))/).any?
        "test"
      else
        ENV["RAILS_ENV"] || "development"
      end

config = YAML.load_file(File.expand_path(env == "test" ? "../example.application.yml" : "../application.yml", __FILE__))

ENV.each do |key, value|
  Object.const_set(Regexp.last_match(1).upcase, value) if key =~ /^OSM_(.*)$/

  ["STAGING", "SPDL", "UK"].each do |account_code|
    if ["ALM_#{account_code}_AUTH_ID",
        "ALM_#{account_code}_AUTH_SECRET"].include?(key)
      Object.const_set(key.upcase, value)
    end
  end
end

config[env].each do |key, value|
  Object.const_set(key.upcase, value) unless Object.const_defined?(key.upcase)
end
