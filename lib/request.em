class Em.Auth.Request
  init: ->
    adapter = Em.String.classify @auth.requestAdapter
    if Em.Auth.Request[adapter]?
      @adapter = Em.Auth.Request[adapter].create({ auth: @auth })
    else
      throw "Adapter not found: Em.Auth.Request.#{adapter}"
    @inject()

  signIn:  (opts) ->
    url = @resolveUrl @auth.signInEndPoint
    @adapter.signIn  url, @auth.strategy.serialize(opts)
  signOut: (opts) ->
    url = @resolveUrl @auth.signOutEndPoint
    @adapter.signOut url, @auth.strategy.serialize(opts)
  send: -> @adapter.send.apply(this, arguments)

  # different base url support
  # @param {path} string the path for resolving full URL
  resolveUrl: (path) ->
    base = @auth.baseUrl
    if base && base[base.length-1] == '/'
      base = base.substr(0, base.length-1)
    if path?[0] == '/'
      path = path.substr(1, path.length)
    [base, path].join('/')

  inject: ->
    @auth.reopen
      signIn:  @signIn
      signOut: @signOut
      send:    @send
