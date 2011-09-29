ActionController::Base.session = {
  :key              => '_tribal_pride',
  :secret           => '73d3d0278f1820fdabe134c17a5ec4fd84de4f2070ad9ea82b88dbb41b1bcd1c7415b0c0e0849429e9072eefe775812f44e62e10f67e43c33d2a92214cd73cc0',
  :expire_after     => 1.day.to_i,
  #:memcache_server  => SESSION_SERVER,
  :httponly         => false,
  :cookie_only      => false
}

#ActionController::Base.session_store = :mem_cache_store
