## METEOR
ServiceConfiguration.configurations.upsert service: 'meteor-developer',
  $set:
    clientId: Meteor.settings.authenticationProviders.meteor.clientId
    secret: Meteor.settings.authenticationProviders.meteor.secret
    loginStyle: 'popup'

## FACEBOOK
ServiceConfiguration.configurations.upsert service: 'facebook',
  $set:
    appId: Meteor.settings.authenticationProviders.facebook.appId
    secret: Meteor.settings.authenticationProviders.facebook.secret
    loginStyle: 'popup'

## TWITTER
ServiceConfiguration.configurations.upsert service: 'twitter',
  $set:
    consumerKey: Meteor.settings.authenticationProviders.twitter.consumerKey
    secret: Meteor.settings.authenticationProviders.twitter.secret
    loginStyle: 'popup'

## GOOGLE
ServiceConfiguration.configurations.upsert service: 'google',
  $set:
    clientId: Meteor.settings.authenticationProviders.google.clientId
    secret: Meteor.settings.authenticationProviders.google.secret
    loginStyle: 'popup'