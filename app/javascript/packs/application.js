
import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
import 'bootstrap'
require("packs/preview-img")
require('./iconify.min')
require('cocoon')
require('./custom')
require('./checkbox')
require('jquery')

Rails.start()

//= require tinymce
Turbolinks.start()
ActiveStorage.start()
global.toastr = require('toastr')
