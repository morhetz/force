sd = require('sharify').data
require('backbone').$ = $

if location.pathname is '/art-fairs'
  $ require('../apps/fairs/client/index').init
else if location.pathname.match('/.*/info.*')
  $ require('../apps/fair_info/client/index').init
else if sd.FAIR_ORGANIZER
  $ require('../apps/fair_organizer/client/index').init
else
  $ require('../apps/fair/client/index').init
