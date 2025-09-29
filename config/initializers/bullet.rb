if defined?(Bullet)
  Bullet.enable = true
  Bullet.bullet_logger = true
  Bullet.rails_logger = true
  Bullet.n_plus_one_query_enable = true
  Bullet.unused_eager_loading_enable = true
end
