local sakls = require 'sakls'
local syntax_provider = require 'sakls.syntax.vimsyn'
sakls.init {
  sakls_lib = {
    path = '/usr/lib/libSAKLS.so',
  },
  layout_backend = 'xkb-switch',
}

---This schema assumes that 0 is the default layout (usually English),
---and 1 is the alternative layout (other language, e.g. Russian).
local vimtex_vimsyn_schema = {
    memorized = {
      ['texAuthorArg'] = 1,
      ['texTitleArg'] = 1,
      ['texStyleBold'] = 1,
      ['texStyleItal'] = 1,
      ['texStyleArgConc'] = 1,
      ['texPartArgTitle'] = 1,
      ['texNewthmArgPrinted'] = 1,
      ['texTheoremEnvOpt'] = 1,
      ['texEnvOpt'] = 1,
      ['texMathTextConcArg'] = 1,
      ['texFootnoteArg'] = 1,
      ['texSectionArg'] = 1,
    },
    forced = {
      -- [''] = 1,
    },
    ignored = {
      ['texDelim'] = true,
      ['texMathDelimZoneTI'] = true,
      ['texRefEqConcealedDelim'] = true,
      ['texGroup'] = true,
      ['texSpecialChar'] = true,
  },
}
sakls.attach_on_filetype("tex", syntax_provider, vimtex_vimsyn_schema)
