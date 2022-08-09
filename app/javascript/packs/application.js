require('jquery')
import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
import 'bootstrap'
require("packs/preview-img")
require('./iconify.min')
require('cocoon')
require('jquery')
import "bootstrap"
require('cocoon')

Rails.start()
Turbolinks.start()
ActiveStorage.start()
global.toastr = require('toastr')
