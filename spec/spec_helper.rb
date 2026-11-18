require 'json'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, %r{api\.themoviedb\.org/3/search/movie})
      .to_return(
        status: 200,
        body: JSON.generate(
          results: [
            {
              title: 'Sydney 2000 Olympics Opening Ceremony',
              release_date: '2000-09-15',
              overview: 'Opening ceremony of the 2000 Summer Olympics.'
            }
          ]
        ),
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end