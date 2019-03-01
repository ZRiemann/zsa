# 1.
# 设置 NODE_ENV 为 'production'
# 相对 default = 'development', 提升3倍性能
export NODE_ENV="production"

# 2.
# var debug = require('debug')('author');
# export DEBUG="author,book"

# 3.
# 启用压缩
# npm install compression
# app.use(compression());
# or Nginx 方向代理

# 4.
# 避免漏洞
# npm install helmet
# app.use(helmet());