require 'jwt'
class JsonWebToken
    # Encodes and signs JWT Payload with expiration
  def self.encode(payload)
    # payload.reverse_merge!(meta)
    payload['exp'] = 6.hours.from_now.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'none')
  end

  # Decodes the JWT with the signed secret
  def self.decode(token)
    payload = HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_base, false)[0])
    unless valid_payload(payload)
      return false
    else
      return payload
    end
  end

  # Validates the payload hash for expiration and meta claims
  def self.valid_payload(payload)
    unless expired(payload)
      return true
    else
      return false
    end
  end
  # check expiry
  def self.expired(payload)
    return Time.at(payload['exp']).to_i < Time.now.to_i
  end

end
