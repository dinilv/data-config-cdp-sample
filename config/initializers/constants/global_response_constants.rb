module GlobalResponseConstants

# ---------\\---- Response Messages ----//----------

   # Successful message
  SUCCESS = {}
  SUCCESS['status'] = true
  SUCCESS['status_code'] = 200
  SUCCESS['message'] = 'Success'
  SUCCESS['data'] = {}

  # Bad Request message
  BAD_REQUEST = {}
  BAD_REQUEST['status'] = true
  BAD_REQUEST['statusCode'] = 400
  BAD_REQUEST['message'] = 'Bad Request'

  # error message
  EXCEPTION = {}
  EXCEPTION['status'] = false
  EXCEPTION['statusCode'] = 500
  EXCEPTION['message'] = 'Internal Server Error'

  # Auth permission error message
  AUTH_ERROR = {}
  AUTH_ERROR['status'] = false
  AUTH_ERROR['statusCode'] = 401
  AUTH_ERROR['message'] = 'Authentication Error'


  # forbidden
  FORBIDDEN = {}
  FORBIDDEN['status'] = false
  FORBIDDEN['statusCode'] = 403
  FORBIDDEN['message'] = 'Forbidden'

  #Any databse Error
  DATABASE_EXCEPTION_UPDATE = {}
  DATABASE_EXCEPTION_UPDATE['status'] = false
  DATABASE_EXCEPTION_UPDATE['statusCode'] = 501
  DATABASE_EXCEPTION_UPDATE['message'] = 'Not Implemented'

  DATABASE_EXCEPTION_CREATE = {}
  DATABASE_EXCEPTION_CREATE['status'] = false
  DATABASE_EXCEPTION_CREATE['statusCode'] = 502
  DATABASE_EXCEPTION_CREATE['message'] = 'Bad Gateway'

  # param validation error message
  NOT_ACCEPTABLE = {}
  NOT_ACCEPTABLE['status'] = false
  NOT_ACCEPTABLE['statusCode'] = 406
  NOT_ACCEPTABLE['message'] = 'Invalid params'

# Validation error message
  REQUEST_INVALID = {}
  REQUEST_INVALID['status'] = false
  REQUEST_INVALID['statusCode'] = 404
  REQUEST_INVALID['message'] = 'Not Found'

  #  No content message
  ZERO_CONTENT = {}
  ZERO_CONTENT['status'] = true
  ZERO_CONTENT['statusCode'] = 204
  ZERO_CONTENT['message'] = 'No Result Found'

  # unprocessable entity
  UNPROCESSABLE = {}
  UNPROCESSABLE['status'] = false
  UNPROCESSABLE['statusCode'] = 422
  UNPROCESSABLE['message'] = 'No Result Found'

  #Standard Response code
  RESP_SUCESS_CODE = 200
  RESP_ERROR_CODE = 500
  MESSAGE = "message"
  STATUS_CODE = "statusCode"
  DATA = "data"
  TOTAL_COUNT = "total_count"



end
