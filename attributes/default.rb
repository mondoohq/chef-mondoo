
default['mondoo'].tap do |mondoo|
  mondoo['registration_token'] = 'change_me'

  mondoo['deb']['repo'] = 'https://releases.mondoo.com/debian/'
  mondoo['deb']['gpgkey'] = 'https://releases.mondoo.com/debian/pubkey.gpg'

  mondoo['rpm']['repo'] = 'https://releases.mondoo.com/rpm/$basearch/'
  mondoo['rpm']['gpgkey'] = 'https://releases.mondoo.com/rpm/pubkey.gpg'
end
