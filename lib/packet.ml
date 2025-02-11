(** Magic numbers of the TLS protocol. *)

(* HACK: 24 bits type not in cstruct *)
let get_uint24_len buf =
  (Cstruct.BE.get_uint16 buf 0) * 0x100 + (Cstruct.get_uint8 buf 2)

let set_uint24_len buf num =
  Cstruct.BE.set_uint16 buf 0 (num / 0x100);
  Cstruct.set_uint8 buf 2 (num mod 0x100)

(* TLS record content type *)
[%%cenum
type content_type =
  | CHANGE_CIPHER_SPEC [@id 20]
  | ALERT              [@id 21]
  | HANDSHAKE          [@id 22]
  | APPLICATION_DATA   [@id 23]
  | HEARTBEAT          [@id 24]
  [@@uint8_t] [@@sexp]
]

(* TLS alert level *)
[%%cenum
type alert_level =
  | WARNING [@id 1]
  | FATAL   [@id 2]
  [@@uint8_t] [@@sexp]
]

(* TLS alert types *)
[%%cenum
type alert_type =
  | CLOSE_NOTIFY                    [@id 0]   (*RFC5246*)
  | UNEXPECTED_MESSAGE              [@id 10]  (*RFC5246*)
  | BAD_RECORD_MAC                  [@id 20]  (*RFC5246*)
  | DECRYPTION_FAILED               [@id 21]  (*RFC5246*)
  | RECORD_OVERFLOW                 [@id 22]  (*RFC5246*)
  | DECOMPRESSION_FAILURE           [@id 30]  (*RFC5246*)
  | HANDSHAKE_FAILURE               [@id 40]  (*RFC5246*)
  | NO_CERTIFICATE_RESERVED         [@id 41]  (*RFC5246*)
  | BAD_CERTIFICATE                 [@id 42]  (*RFC5246*)
  | UNSUPPORTED_CERTIFICATE         [@id 43]  (*RFC5246*)
  | CERTIFICATE_REVOKED             [@id 44]  (*RFC5246*)
  | CERTIFICATE_EXPIRED             [@id 45]  (*RFC5246*)
  | CERTIFICATE_UNKNOWN             [@id 46]  (*RFC5246*)
  | ILLEGAL_PARAMETER               [@id 47]  (*RFC5246*)
  | UNKNOWN_CA                      [@id 48]  (*RFC5246*)
  | ACCESS_DENIED                   [@id 49]  (*RFC5246*)
  | DECODE_ERROR                    [@id 50]  (*RFC5246*)
  | DECRYPT_ERROR                   [@id 51]  (*RFC5246*)
  | EXPORT_RESTRICTION_RESERVED     [@id 60]  (*RFC5246*)
  | PROTOCOL_VERSION                [@id 70]  (*RFC5246*)
  | INSUFFICIENT_SECURITY           [@id 71]  (*RFC5246*)
  | INTERNAL_ERROR                  [@id 80]  (*RFC5246*)
  | INAPPROPRIATE_FALLBACK          [@id 86]  (*draft-ietf-tls-downgrade-scsv*)
  | USER_CANCELED                   [@id 90]  (*RFC5246*)
  | NO_RENEGOTIATION                [@id 100] (*RFC5246*)
  | MISSING_EXTENSION               [@id 109] (*RFC8446*)
  | UNSUPPORTED_EXTENSION           [@id 110] (*RFC5246*)
  | CERTIFICATE_UNOBTAINABLE        [@id 111] (*RFC6066*)
  | UNRECOGNIZED_NAME               [@id 112] (*RFC6066*)
  | BAD_CERTIFICATE_STATUS_RESPONSE [@id 113] (*RFC6066*)
  | BAD_CERTIFICATE_HASH_VALUE      [@id 114] (*RFC6066*)
  | UNKNOWN_PSK_IDENTITY            [@id 115] (*RFC4279*)
  | CERTIFICATE_REQUIRED            [@id 116] (*RFC8446*)
  | NO_APPLICATION_PROTOCOL         [@id 120] (*RFC7301*)
  [@@uint8_t] [@@sexp]
]

(* TLS handshake type *)
[%%cenum
type handshake_type =
  | HELLO_REQUEST        [@id 0]
  | CLIENT_HELLO         [@id 1]
  | SERVER_HELLO         [@id 2]
  | HELLO_VERIFY_REQUEST [@id 3] (*RFC6347*)
  | SESSION_TICKET       [@id 4] (*RFC4507, RFC8446*)
  | END_OF_EARLY_DATA    [@id 5] (*RFC8446*)
  | ENCRYPTED_EXTENSIONS [@id 8] (*RFC8446*)
  | CERTIFICATE          [@id 11]
  | SERVER_KEY_EXCHANGE  [@id 12]
  | CERTIFICATE_REQUEST  [@id 13]
  | SERVER_HELLO_DONE    [@id 14]
  | CERTIFICATE_VERIFY   [@id 15]
  | CLIENT_KEY_EXCHANGE  [@id 16]
  | FINISHED             [@id 20]
  | CERTIFICATE_URL      [@id 21] (*RFC4366*)
  | CERTIFICATE_STATUS   [@id 22] (*RFC4366*)
  | SUPPLEMENTAL_DATA    [@id 23] (*RFC4680*)
  | KEY_UPDATE           [@id 24] (*RFC8446*)
  | MESSAGE_HASH         [@id 254] (*RFC8446*)
  [@@uint8_t] [@@sexp]
]

(* TLS certificate types *)
[%%cenum
type client_certificate_type =
  | RSA_SIGN                  [@id 1]  (*RFC5246*)
  | DSS_SIGN                  [@id 2]  (*RFC5246*)
  | RSA_FIXED_DH              [@id 3]  (*RFC5246*)
  | DSS_FIXED_DH              [@id 4]  (*RFC5246*)
  | RSA_EPHEMERAL_DH_RESERVED [@id 5]  (*RFC5246*)
  | DSS_EPHEMERAL_DH_RESERVED [@id 6]  (*RFC5246*)
  | FORTEZZA_DMS_RESERVED     [@id 20] (*RFC5246*)
  | ECDSA_SIGN                [@id 64] (*RFC4492*)
  | RSA_FIXED_ECDH            [@id 65] (*RFC4492*)
  | ECDSA_FIXED_ECDH          [@id 66] (*RFC4492*)
  [@@uint8_t] [@@sexp]
]

(* TLS compression methods, used in hello packets *)
[%%cenum
type compression_method =
  | NULL    [@id 0]
  | DEFLATE [@id 1]
  | LZS     [@id 64]
  [@@uint8_t] [@@sexp]
]

(* TLS extensions in hello packets from RFC 6066, formerly RFC 4366 *)
[%%cenum
type extension_type =
  | SERVER_NAME                            [@id 0]
  | MAX_FRAGMENT_LENGTH                    [@id 1]
  | CLIENT_CERTIFICATE_URL                 [@id 2]
  | TRUSTED_CA_KEYS                        [@id 3]
  | TRUNCATED_HMAC                         [@id 4]
  | STATUS_REQUEST                         [@id 5]
  | USER_MAPPING                           [@id 6]  (*RFC4681*)
  | CLIENT_AUTHZ                           [@id 7]  (*RFC5878*)
  | SERVER_AUTHZ                           [@id 8]  (*RFC5878*)
  | CERT_TYPE                              [@id 9]  (*RFC6091*)
  | SUPPORTED_GROUPS                       [@id 10] (*RFC4492, RFC8446*)
  | EC_POINT_FORMATS                       [@id 11] (*RFC4492*)
  | SRP                                    [@id 12] (*RFC5054*)
  | SIGNATURE_ALGORITHMS                   [@id 13] (*RFC5246*)
  | USE_SRTP                               [@id 14] (*RFC5764*)
  | HEARTBEAT                              [@id 15] (*RFC6520*)
  | APPLICATION_LAYER_PROTOCOL_NEGOTIATION [@id 16] (*RFC7301*)
  | STATUS_REQUEST_V2                      [@id 17] (*RFC6961*)
  | SIGNED_CERTIFICATE_TIMESTAMP           [@id 18] (*RFC6962*)
  | CLIENT_CERTIFICATE_TYPE                [@id 19] (*RFC7250*)
  | SERVER_CERTIFICATE_TYPE                [@id 20] (*RFC7250*)
  | PADDING                                [@id 21] (*RFC7685*)
  | ENCRYPT_THEN_MAC                       [@id 22] (*RFC7366*)
  | EXTENDED_MASTER_SECRET                 [@id 23] (*RFC7627*)
  | TOKEN_BINDING                          [@id 24] (*RFC8472*)
  | CACHED_INFO                            [@id 25] (*RFC7924*)
  | TLS_LTS                                [@id 26] (*draft-gutmann-tls-lts*)
  | COMPRESSED_CERTIFICATE                 [@id 27] (*draft-ietf-tls-certificate-compression*)
  | RECORD_SIZE_LIMIT                      [@id 28] (*RFC8449*)
  | PWD_PROTECT                            [@id 29] (*RFC-harkins-tls-dragonfly-03*)
  | PWD_CLEAR                              [@id 30] (*RFC-harkins-tls-dragonfly-03*)
  | PASSWORD_SALT                          [@id 31] (*RFC-harkins-tls-dragonfly-03*)
  | SESSION_TICKET                         [@id 35] (*RFC4507*)
  | PRE_SHARED_KEY                         [@id 41] (*RFC8446*)
  | EARLY_DATA                             [@id 42] (*RFC8446*)
  | SUPPORTED_VERSIONS                     [@id 43] (*RFC8446*)
  | COOKIE                                 [@id 44] (*RFC8446*)
  | PSK_KEY_EXCHANGE_MODES                 [@id 45] (*RFC8446*)
  | CERTIFICATE_AUTHORITIES                [@id 47] (*RFC8446*)
  | OID_FILTERS                            [@id 48] (*RFC8446*)
  | POST_HANDSHAKE_AUTH                    [@id 49] (*RFC8446*)
  | SIGNATURE_ALGORITHMS_CERT              [@id 50] (*RFC8446*)
  | KEY_SHARE                              [@id 51] (*RFC8446*)
  | RENEGOTIATION_INFO                     [@id 0xFF01] (*RFC5746*)
  | DRAFT_SUPPORT                          [@id 0xFF02] (*draft*)
  [@@uint16_t] [@@sexp]
]

(* TLS maximum fragment length *)
[%%cenum
type max_fragment_length =
  | TWO_9  [@id 1]
  | TWO_10 [@id 2]
  | TWO_11 [@id 3]
  | TWO_12 [@id 4]
  [@@uint8_t] [@@sexp]
]

(* TLS 1.3 pre-shared key mode (4.2.9) *)
[%%cenum
type psk_key_exchange_mode =
  | PSK_KE [@id 0]
  | PSK_KE_DHE [@id 1]
  [@@uint8_t] [@@sexp]
]

(* TLS 1.3 4.2.3 *)
[%%cenum
type signature_alg =
  | RSA_PKCS1_MD5    [@id 0x0101] (* deprecated, TLS 1.2 only *)
  | RSA_PKCS1_SHA1   [@id 0x0201] (* deprecated, TLS 1.2 only *)
  | RSA_PKCS1_SHA224 [@id 0x0301]
  | RSA_PKCS1_SHA256 [@id 0x0401]
  | RSA_PKCS1_SHA384 [@id 0x0501]
  | RSA_PKCS1_SHA512 [@id 0x0601]
  | ECDSA_SECP256R1_SHA1 [@id 0x0203] (* deprecated, TLS 1.2 only *)
  | ECDSA_SECP256R1_SHA256 [@id 0x0403]
  | ECDSA_SECP384R1_SHA384 [@id 0x0503]
  | ECDSA_SECP521R1_SHA512 [@id 0x0603]
  | RSA_PSS_RSAENC_SHA256 [@id 0x0804]
  | RSA_PSS_RSAENC_SHA384 [@id 0x0805]
  | RSA_PSS_RSAENC_SHA512 [@id 0x0806]
  | ED25519 [@id 0x0807]
  | ED448 [@id 0x0808]
  | RSA_PSS_PSS_SHA256 [@id 0x0809]
  | RSA_PSS_PSS_SHA384 [@id 0x080a]
  | RSA_PSS_PSS_SHA512 [@id 0x080b]
  (* private use 0xFE00 - 0xFFFF *)
  [@@uint16_t] [@@sexp]
]

let to_signature_alg = function
  | `RSA_PKCS1_MD5 -> RSA_PKCS1_MD5
  | `RSA_PKCS1_SHA1 -> RSA_PKCS1_SHA1
  | `RSA_PKCS1_SHA224 -> RSA_PKCS1_SHA224
  | `RSA_PKCS1_SHA256 -> RSA_PKCS1_SHA256
  | `RSA_PKCS1_SHA384 -> RSA_PKCS1_SHA384
  | `RSA_PKCS1_SHA512 -> RSA_PKCS1_SHA512
  | `RSA_PSS_RSAENC_SHA256 -> RSA_PSS_RSAENC_SHA256
  | `RSA_PSS_RSAENC_SHA384 -> RSA_PSS_RSAENC_SHA384
  | `RSA_PSS_RSAENC_SHA512 -> RSA_PSS_RSAENC_SHA512
  | `ECDSA_SECP256R1_SHA1 -> ECDSA_SECP256R1_SHA1
  | `ECDSA_SECP256R1_SHA256 -> ECDSA_SECP256R1_SHA256
  | `ECDSA_SECP384R1_SHA384 -> ECDSA_SECP384R1_SHA384
  | `ECDSA_SECP521R1_SHA512 -> ECDSA_SECP521R1_SHA512
  | `ED25519 -> ED25519

let of_signature_alg = function
  | RSA_PKCS1_MD5 -> Some `RSA_PKCS1_MD5
  | RSA_PKCS1_SHA1 -> Some `RSA_PKCS1_SHA1
  | RSA_PKCS1_SHA224 -> Some `RSA_PKCS1_SHA224
  | RSA_PKCS1_SHA256 -> Some `RSA_PKCS1_SHA256
  | RSA_PKCS1_SHA384 -> Some `RSA_PKCS1_SHA384
  | RSA_PKCS1_SHA512 -> Some `RSA_PKCS1_SHA512
  | RSA_PSS_RSAENC_SHA256 -> Some `RSA_PSS_RSAENC_SHA256
  | RSA_PSS_RSAENC_SHA384 -> Some `RSA_PSS_RSAENC_SHA384
  | RSA_PSS_RSAENC_SHA512 -> Some `RSA_PSS_RSAENC_SHA512
  | ECDSA_SECP256R1_SHA1 -> Some `ECDSA_SECP256R1_SHA1
  | ECDSA_SECP256R1_SHA256 -> Some `ECDSA_SECP256R1_SHA256
  | ECDSA_SECP384R1_SHA384 -> Some `ECDSA_SECP384R1_SHA384
  | ECDSA_SECP521R1_SHA512 -> Some `ECDSA_SECP521R1_SHA512
  | ED25519 -> Some `ED25519
  | _ -> None

(* EC RFC4492*)
[%%cenum
type ec_curve_type =
  (* 1 and 2 are deprecated in RFC 8422 *)
  | NAMED_CURVE    [@id 3]
  [@@uint8_t] [@@sexp]
]

[%%cenum
type named_group =
  (* OBSOLETE_RESERVED 0x0001 - 0x0016 *)
  | SECP256R1 [@id 23]
  | SECP384R1 [@id 24]
  | SECP521R1 [@id 25]
  (* OBSOLETE_RESERVED 0x001A - 0x001C *)
  | X25519          [@id 29] (*RFC8446*)
  | X448            [@id 30] (*RFC8446*)
  | FFDHE2048       [@id 256] (*RFC8446*)
  | FFDHE3072       [@id 257] (*RFC8446*)
  | FFDHE4096       [@id 258] (*RFC8446*)
  | FFDHE6144       [@id 259] (*RFC8446*)
  | FFDHE8192       [@id 260] (*RFC8446*)
  (* FFDHE_PRIVATE_USE 0x01FC - 0x01FF *)
  (* ECDHE_PRIVATE_USE 0xFE00 - 0xFEFF *)
  (* OBSOLETE_RESERVED 0xFF01 - 0xFF02 *)
  [@@uint16_t] [@@sexp]
]

(** enum of all TLS ciphersuites *)
[%%cenum
type any_ciphersuite =
  | TLS_RSA_WITH_3DES_EDE_CBC_SHA          [@id 0x000A]
  | TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA      [@id 0x0016]
  (* from RFC 3268 *)
  | TLS_RSA_WITH_AES_128_CBC_SHA      [@id 0x002F]
  | TLS_DHE_RSA_WITH_AES_128_CBC_SHA  [@id 0x0033]
  | TLS_RSA_WITH_AES_256_CBC_SHA      [@id 0x0035]
  | TLS_DHE_RSA_WITH_AES_256_CBC_SHA  [@id 0x0039]
  (* from RFC 5246 *)
  | TLS_RSA_WITH_AES_128_CBC_SHA256          [@id 0x003C]
  | TLS_RSA_WITH_AES_256_CBC_SHA256          [@id 0x003D]
  | TLS_DHE_RSA_WITH_AES_128_CBC_SHA256      [@id 0x0067]
  | TLS_DHE_RSA_WITH_AES_256_CBC_SHA256      [@id 0x006B]
  | TLS_RSA_WITH_AES_128_GCM_SHA256          [@id 0x009C] (*RFC5288*)
  | TLS_RSA_WITH_AES_256_GCM_SHA384          [@id 0x009D] (*RFC5288*)
  | TLS_DHE_RSA_WITH_AES_128_GCM_SHA256      [@id 0x009E] (*RFC5288*)
  | TLS_DHE_RSA_WITH_AES_256_GCM_SHA384      [@id 0x009F] (*RFC5288*)
  | TLS_EMPTY_RENEGOTIATION_INFO_SCSV        [@id 0x00FF] (*RFC5746*)
  | TLS_AES_128_GCM_SHA256                   [@id 0x1301] (*RFC8446*)
  | TLS_AES_256_GCM_SHA384                   [@id 0x1302] (*RFC8446*)
  | TLS_CHACHA20_POLY1305_SHA256             [@id 0x1303] (*RFC8446*)
  | TLS_AES_128_CCM_SHA256                   [@id 0x1304] (*RFC8446*)
  | TLS_FALLBACK_SCSV                        [@id 0x5600] (*draft-ietf-tls-downgrade-scsv*)
  (* from RFC 4492 *)
  | TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA        [@id 0xC008]
  | TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA         [@id 0xC009]
  | TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA         [@id 0xC00A]
  | TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA          [@id 0xC012]
  | TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA           [@id 0xC013]
  | TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA           [@id 0xC014]
  | TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256      [@id 0xC023] (*RFC5289*)
  | TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384      [@id 0xC024] (*RFC5289*)
  | TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256        [@id 0xC027] (*RFC5289*)
  | TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384        [@id 0xC028] (*RFC5289*)
  | TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256      [@id 0xC02B] (*RFC5289*)
  | TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384      [@id 0xC02C] (*RFC5289*)
  | TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256        [@id 0xC02F] (*RFC5289*)
  | TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384        [@id 0xC030] (*RFC5289*)
  | TLS_RSA_WITH_AES_128_CCM                     [@id 0xC09C] (*RFC6655*)
  | TLS_RSA_WITH_AES_256_CCM                     [@id 0xC09D] (*RFC6655*)
  | TLS_DHE_RSA_WITH_AES_128_CCM                 [@id 0xC09E] (*RFC6655*)
  | TLS_DHE_RSA_WITH_AES_256_CCM                 [@id 0xC09F] (*RFC6655*)
  | TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256  [@id 0xCCA8] (*RFC7905*)
  | TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256 [@id 0xCCA9] (*RFC7905*)
  | TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256    [@id 0xCCAA] (*RFC7905*)
  [@@uint16_t] [@@sexp]
]

[%%cenum
type key_update_request_type =
  | UPDATE_NOT_REQUESTED [@id 0]
  | UPDATE_REQUESTED [@id 1]
  [@@uint8_t] [@@sexp]
]

let helloretryrequest = Mirage_crypto.Hash.digest `SHA256 (Cstruct.of_string "HelloRetryRequest")
let downgrade12 = Cstruct.of_hex "44 4F 57 4E 47 52 44 01"
let downgrade11 = Cstruct.of_hex "44 4F 57 4E 47 52 44 00"
