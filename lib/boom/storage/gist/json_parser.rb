# coding: utf-8

# Crack's parsing is no bueno. Use the MultiJson instead.
class JsonParser < HTTParty::Parser
  def json
    MultiJson.decode(body)
  end
end
