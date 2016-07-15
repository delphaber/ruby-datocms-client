require 'spec_helper'

module Dato
  module Account
    describe Client do
      let(:client) do
        Dato::Account::Client.new(
          "7afb9e8e8d822c7d2cff7ea0d69fd5353d66adc00eeb2da05d",
          domain: "http://account-api.lvh.me:3001"
        )
      end

      describe 'Not found' do
        it 'raises Faraday::ClientError' do
          expect { client.sites.find(9999) }.to raise_error Faraday::ClientError
        end
      end

      describe 'Sites' do
        it 'fetch, create, update and destroy' do
          new_site = client.sites.create(name: "Foobar")

          client.sites.update(
            new_site[:id],
            new_site.merge(name: "Blog")
          )

          expect(client.sites.all.size).to eq 1
          expect(client.sites.find(new_site[:id])[:name]).to eq "Blog"

          client.sites.destroy(new_site[:id])
          expect(client.sites.all.size).to eq 0
        end
      end
    end
  end
end
