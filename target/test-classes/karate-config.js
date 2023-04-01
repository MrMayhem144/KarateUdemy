function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://api.realworld.io/api/'
  }
  if (env == 'dev') {
    config.userEmail = 'gustavo.teo@outlook.com'
    config.userPassword = '12345'
    config.userSlug = 151592
  } else if (env == 'hml') {
    config.userEmail = 'fsociety669@email.com'
    config.userPassword = '67890'
    config.userSlug = 151722
  }

  var acessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + acessToken})

  return config;
}