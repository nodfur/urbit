/-  spider, claz
/+  *strand, azio, *ethereum, *azimuth
::
=/  az
  %~  .  azio
  :-  'https://mainnet.infura.io/v3/2599df54929b47099bda360958d75aaf'
  =>  mainnet-contracts
  :*  azimuth
      ecliptic
      linear-star-release
      delegated-sending
  ==
::
=/  ceremony=address
  0x740d.6d74.1711.163d.3fca.cecf.1f11.b867.9a7c.7964
::
=/  deep-safe=address
  0x1111.1111.1111.1111.1111.1111.1111.1111.1111.1111
=/  lockup-safe=$-(@p address)
  |=  g=@p
  ::  0x2222.2222.2222.2222.2222.2222.2222.2222.2222.00xx
   `address`(rep 4 g (reap 9 0x2222))
=/  shallow-safe=address
  0x3333.3333.3333.3333.3333.3333.3333.3333.3333.3333
=/  proxy-safe=address
  0x4444.4444.4444.4444.4444.4444.4444.4444.4444.4444
::
=/  gax=(list [gal=@p own=? loc=?])
  :~  [~bus & |]
      [~def & |]
      [~dev & |]
      [~lur & |]
      [~pem & |]
      [~pub & |]
      [~sud & |]
      [~ten & |]
      [~zod & |]
      [~nus & |]
      [~feb & |]
      [~fet & |]
      [~nes & |]
      [~rud & |]
      [~rel & |]
      [~bec & &]
      [~bep & &]
      [~ber & &]
      [~byl & &]
      [~byr & &]
      [~byt & &]
      [~deb & &]
      [~dem & &]
      [~dun & |]
      [~dyt & &]
      [~fen & &]
      [~fur & &]
      [~fyl & &]
      [~hul & &]
      [~hus & &]
      [~hut & &]
      [~lec & &]
      [~len & &]
      [~lep & &]
      [~ler & &]
      [~lev & &]
      [~luc & &]
      [~lud & &]
      [~lyn & &]
      [~lyr & &]
      [~lys & &]
      [~mel & &]
      [~mex & &]
      [~mug & &]
      [~mun & &]
      [~mur & &]
      [~myl & &]
      [~ned & &]
      [~nel & &]
      [~ner & &]
      [~nev & &]
      [~nyd & &]
      [~nyl & &]
      [~nys & &]
      [~pec & &]
      [~pex & &]
      [~rem & &]
      [~ret & &]
      [~ryc & &]
      [~ryd & &]
      [~ryl & &]
      [~rym & &]
      [~seb & &]
      [~sed & &]
      [~sen & &]
      [~sug & &]
      [~syl & &]
      [~tec & &]
      [~teg & &]
      [~tel & &]
      [~tes & &]
      [~tuc & &]
      [~tun & &]
      [~tus | &]
      [~wed | &]
      [~weg | &]
      [~wer & &]
      [~bel & &]
      [~ben | &]
      [~bet | &]
      [~bex & &]
      [~deg & &]
      [~det & &]
      [~dus & &]
      [~dut & &]
      [~dux & &]
      [~dyl & &]
      [~fel & &]
      [~lyx & &]
      [~meb & &]
      [~mec & &]
      [~med & &]
      [~meg & &]
      [~mes & &]
      [~myn & &]
      [~myr & &]
      [~neb & &]
      [~nub & &]
      [~nux & &]
      [~pel & &]
      [~rec & &]
      [~ren & &]
      [~res & &]
      [~rev & &]
      [~rux & &]
      [~ryn & &]
      [~seg & &]
      [~set & &]
      [~sur & &]
      [~syp & &]
      [~ted & &]
      [~ter & &]
      [~tex & &]
      [~tud & &]
      [~tyn & &]
      [~wet & &]
      [~wyt & &]
  ==
::
=/  saz=(list @p)
  :~  ~marzod
      ~binzod
      ~samzod
      ~wanzod
      ~litzod
    ::
      ::NOTE  ~tonwet owned but is outgoing transfer
  ==
::
=/  known=(list @p)
  (weld saz (turn gax head))
::
~&  [%ecliptic ecliptic:mainnet-contracts]
::
^-  thread:spider
|=  args=vase
=/  m  (strand ,vase)
^-  form:m
=|  owned=(map address (list @p))  ::  cache
=|  out=(jar address batch:claz)
::  handle galaxies and lockups
::
|-
=*  loop-gax  $
?^  gax
  =,  i.gax
  ::  if we don't expect to own it, just no-op check for lockups
  ::
  ?.  own
    ;<  =deed:eth-noun  bind:m
      (rights:azimuth:az (rep 3 gal 1 ~))
    =/  lockup=?
      .=  owner.deed
      linear-star-release:mainnet-contracts
    ~?  &(loc lockup)
      [%need-manual-lockup-discovery gal]
    ~?  &(!loc lockup)
      [%make-sure-we-dont-own-lockup-for gal]
    loop-gax(gax t.gax)
  ::  get the owner address, use it to config & transfer the galaxy
  ::
  ;<  =deed:eth-noun  bind:m
    (rights:azimuth:az gal)
  ~?  !=(0x0 transfer-proxy.deed)
    [%unexpected-transfer-proxy gal transfer-proxy.deed]
  =.  out
    %+  ~(add ja out)  owner.deed
    ^-  batch:claz
    :-  %more
    :~  [%single %set-management-proxy gal shallow-safe]
        [%single %set-voting-proxy gal proxy-safe]
        ::TODO  spawn proxy if stars remaining
        ::      to shallow if < 50, otherwise deep
        ::TODO  printf about that briefly
        [%single %transfer-ship gal deep-safe]
    ==
  ::  if it controls a lockup, transfer that too
  ::
  ;<  =batch:linear:az  bind:m
    (batches:linear:az owner.deed)
  =/  transferring=?
    &(!=(0x0 approved.batch) !=(owner.deed approved.batch))
  ?:  =(0 amount.batch)
    ~?  loc  [%missing-lockup gal owner.deed]
    loop-gax(gax t.gax)
  ~?  &(!loc !transferring)  [%unexpected-lockup gal owner.deed amount.batch]
  ~?  &(loc transferring)    [%unexpected-lockup-transfer gal owner.deed amount.batch approved.batch]
  ::  only transfer the lockup if we expected it
  ::
  =?  out  loc
    %+  ~(add ja out)  owner.deed
    [%single %approve-batch-transfer (lockup-safe gal)]
  =?  out  loc
    %+  ~(add ja out)  (lockup-safe gal)
    [%single %transfer-batch owner.deed]
  ::  find other assets controlled by this address
  ::
  ;<  others=(list @p)  bind:m
    =/  m  (strand ,(list @p))
    ?^  h=(~(get by owned) owner.deed)  (pure:m u.h)
    (get-owned-points:azimuth:az owner.deed)
  =.  owned  (~(put by owned) owner.deed others)
  =.  others  (skip others |=(=@p ?=(^ (find [p]~ known))))
  ~?  !=(~ others)
    [%has-others gal owner.deed others]
  ::
  loop-gax(gax t.gax)
::
::  handle stars
::
|-
=*  loop-saz  $
?^  saz
  =*  star  i.saz
  ::  get the owner address, use it to config & transfer the star
  ::
  ;<  =deed:eth-noun  bind:m
    (rights:azimuth:az star)
    ~?  !=(0x0 transfer-proxy.deed)
    [%unexpected-transfer-proxy star transfer-proxy.deed]
  =.  out
    %+  ~(add ja out)  owner.deed
    ^-  batch:claz
    :-  %more
    :~  [%single %set-management-proxy star shallow-safe]
        [%single %set-spawn-proxy star proxy-safe]
        [%single %transfer-ship star deep-safe]
    ==
  ::  find other assets controlled by this address
  ::
  ;<  others=(list @p)  bind:m
    =/  m  (strand ,(list @p))
    ?^  h=(~(get by owned) owner.deed)  (pure:m u.h)
    (get-owned-points:azimuth:az owner.deed)
  =.  owned  (~(put by owned) owner.deed others)
  =.  others  (skip others |=(=@p ?=(^ (find [p]~ known))))
  ::NOTE  we exclude ~litzod because it has many spawned-but-pending planets
  ~?  &(!=(~ others) !=(~litzod star))
    [%has-others star owner.deed others]
  loop-saz(saz t.saz)
::
::  ceremony address
::
;<  others=(list @p)  bind:m
  =/  m  (strand ,(list @p))
  ?^  h=(~(get by owned) ceremony)  (pure:m u.h)
  (get-owned-points:azimuth:az ceremony)
=.  others  (skip others |=(=@p ?=(^ (find [p]~ known))))
::
=.  out
  %+  ~(add ja out)  ceremony
  ^-  batch:claz
  :-  %more
  =,  mainnet-contracts
  :~  [%custom ecliptic 0 'transferOwnership' [%address deep-safe]~]
      [%custom linear-star-release 0 'transferOwnership' [%address deep-safe]~]
      [%custom conditional-star-release 0 'transferOwnership' [%address shallow-safe]~]
  ==
::
::NOTE  flop because +ja adds to list head
::TODO  poke claz instead
(pure:m !>((~(run by out) flop)))