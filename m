Return-Path: <linux-fscrypt+bounces-1529-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MLufKdMXtWkBwgAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1529-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Mar 2026 09:09:55 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F07B28C0C5
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Mar 2026 09:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3CC133027DBF
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Mar 2026 08:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B374A31F99B;
	Sat, 14 Mar 2026 08:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ow/uDjHT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tnTxZ+6J"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F73313545
	for <linux-fscrypt@vger.kernel.org>; Sat, 14 Mar 2026 08:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773475790; cv=none; b=LZDnHEfDe6AA+/1rq/fAbF0PEXrOhyXwRv+gic9hA3h3AfVyInS+tSHUFlI71TtgsSXUo5KJ1vLX2Q8kk3UxOdlT5lyhYCziEc72C4MaVFnO4SIBJdfiEiJ9Gdz1r5jdfgyqffLXlzAmiHcVqGBVLGLgpwpqVDwyqOUZrbgOUaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773475790; c=relaxed/simple;
	bh=ol8G3DArL5RCvist80biplurEGSMBotX5FbrElSFfb0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hA2gl6UO49IRqJC/TF7lIXFO8tIocVT8Ua6NoWch2gEsyGcWr3lCLt3Q5jge3G8C+hdF3yg+XGkquRARJ/Ffq2QNxEvWFpzrcHG1l5cWPjYQSejWJJUDR6fDxGqwzq7GpcaArfYie8nzr7ajQwK0WF4r5q4FUxcjuF09yDwdpCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ow/uDjHT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tnTxZ+6J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773475787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8PAvLIaKHWodhamivEyy4yfXvUSRuaied/GyU0GOYh4=;
	b=Ow/uDjHTa3RRzas13RTqqfXyEcKvWqCkUiTw3GKp0Zt/fjVSClJOS9QXnV9iTpCaj7t6+y
	797Bph7+vyuPtrDsAF6VFkBuI48AMkakqxDW9wyJa2mFaIYI5Dc0OGhDNfe2ldOEqXxpev
	0dR9ueig44DCevhPGloInW74cHMhJAg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-MqXyXr7ENqerDMSITMeeNA-1; Sat, 14 Mar 2026 04:09:45 -0400
X-MC-Unique: MqXyXr7ENqerDMSITMeeNA-1
X-Mimecast-MFC-AGG-ID: MqXyXr7ENqerDMSITMeeNA_1773475784
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aecbb78e44so76459495ad.2
        for <linux-fscrypt@vger.kernel.org>; Sat, 14 Mar 2026 01:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773475783; x=1774080583; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PAvLIaKHWodhamivEyy4yfXvUSRuaied/GyU0GOYh4=;
        b=tnTxZ+6JVAAklfvUBS5Aft+ExbCoBnx3qJn2qY1Z+ETpxUG+kd1HOILkipO8vS5dO/
         hKfXjZwTRIbod+f+rVU2qv65cLbsuna1LYkaAwCMzIQg2DhooM8BpuvSppIc/KoBu2e+
         H+z/P+Mf7vuTqWQmZS48t0H7BMujxQt5I6YUqTDqVFErT8fbgOvsahs2pIJjuCeqi39A
         kBeag0Vb781E2k4Niy79VCR2eq85NFAemjIeuLOrYXoJwoNXPgMatZFoodebFjW/YoRW
         A1hTv92RIiIb1xDJkwic3ddDoAVd03/Z9xnraItc+NdfOe2JRMYHVvfImRVwPfyqiMaK
         DbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773475783; x=1774080583;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8PAvLIaKHWodhamivEyy4yfXvUSRuaied/GyU0GOYh4=;
        b=FiZ48vDgpPvceuDcTYTptt0grRnn4g/3tN0VEwqvu3HrwZzoXRvqXXKSgE+p5MRAih
         i9DnEC+4plQmCmXLfx9YdTm3kl+S+RFPJERZdlbehC8/haoZo+80ZDKJBdcTQQPHAdU7
         Z4/G38Un/pWv4ePNK7c+HrfYk43RqKSGTP06adUCn7l2Izy+mlgoSetp/T1paGsQbYqu
         I3QBo9RQmXF4VBoHJJUvyZ26fNKOKb1hAYB5EbZtrEPfkfh05W0t2pXpc4/UAVJID1dR
         1SSOcqKH3ZBfVU3Dd2y2juO3Aq98nIFl+/vnE8hvmK1MabPvwREqREOzmyXIfjg2F2zm
         aC5g==
X-Forwarded-Encrypted: i=1; AJvYcCWEgZZjPFrH5PV2mzFISVR8byGbO59g6ACL0zFACBe2vCGVF4Y3eZmlySPhlG8HG3TdVAiGuLV9WgS15Z2T@vger.kernel.org
X-Gm-Message-State: AOJu0YzszQ8oy6SQoBsbyX2iNgJBxXPFIJiHQeF+d02bDT5gQLbODYYU
	kMbyHNwzHqjknprEWp8STai+zk84h0j3AfYTZ+aKMD6vIVKqOiIKVG9a7Jf6CjU6HKRsKMAcTpC
	3BN5wl/Ad5u1ZZwTRwgd37DtXeeqyYgf2wbdYl3E/ic6tHNF24IAR0p3otSyYX07riQw=
X-Gm-Gg: ATEYQzzg5Knrs/NEG/BrSsC3jlxLanP2qwbTaGMlOdntGRDc4NwWNlXlsvSNHiWLJ7d
	/JR0zOXp/sIuVthuSf8mR2TIImEYOZ4s98C5j1B1TI2rTew+qaSB2+Ci48W/S7Dch6rpJAtMYBn
	ujNVTPd3IQVZ6zM79OXN3MGBY91zVIqUp1TkGKnXeFudiSmbcILwCaT3HQEbeYbZcgq3KsOlFla
	UHCc+s0k/UgZ12sW3G6e2BZjGHeQKFTlazRGOe3qV84CPIfNA6Reos/tYTiXcxK0vIygPPlDQzw
	aStJn3fRoTzpIsz8cmBkDUnkVY649hwaQDt9JnnsA9vpgf0MxPQi50ah/gxb3WmflKirYpgvUNI
	2aefE3b+vJI+EXeEFithOFW9Au8uLVrFilcLhRbeyadR5aeKCRa1x13/caV35Pg==
X-Received: by 2002:a17:903:2985:b0:2ae:b9cd:d2f2 with SMTP id d9443c01a7336-2aecaaad204mr66262145ad.33.1773475782723;
        Sat, 14 Mar 2026 01:09:42 -0700 (PDT)
X-Received: by 2002:a17:903:2985:b0:2ae:b9cd:d2f2 with SMTP id d9443c01a7336-2aecaaad204mr66261815ad.33.1773475782137;
        Sat, 14 Mar 2026 01:09:42 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece5c65b0sm44584265ad.23.2026.03.14.01.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 01:09:41 -0700 (PDT)
Date: Sat, 14 Mar 2026 16:09:37 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [Bug report][xfstests ext4/024 crash on ext4&fscrypt] kernel BUG at
 lib/list_debug.c:32! 
Message-ID: <20260314080937.pghb4aa7d4je3mhh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	SUBJECT_ENDS_SPACES(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1529-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zlang@redhat.com,linux-fscrypt@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	SUBJECT_ENDS_EXCLAIM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dell-per750-06-vm-08.rhts.eng.pek2.redhat.com:mid]
X-Rspamd-Queue-Id: 1F07B28C0C5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

I'm currently running regression tests across various filesystems on linux
v7.0-rc3+ (HEAD=399af66228cfd7df79dc360810b6b673000f8090) before releasing
new fstests version. During my testing, I hit a crash several times with
ext4 on aarch64 (didn't hit it on other arches).

The console output showed a kernel warning about crypto/crypto_engine.c at
first:
  [  858.822866] WARNING: crypto/crypto_engine.c:55 at crypto_finalize_request+0x2bc/0x368 [crypto_engine], CPU#1: 15820000.crypto/587

then showed a bug at lib/list_debug.c and bad non-executable memory access:
  [  858.834134] kernel BUG at lib/list_debug.c:32!
  ...
  [  859.423056] Unable to handle kernel execute from non-executable memory at virtual address ffff80009c6a68b0
  ...

at last, it hit below warning when tried to make kdump:
  [  860.748125] Some CPUs may be stale, kdump will be unreliable.
  [  860.748294] WARNING: arch/arm64/kernel/machine_kexec.c:174 at machine_kexec+0x60/0x3c0, CPU#7: kworker/u50:4/65459

About more details please refer to the completed console output [1].

Thanks,
Zorro

[1]
[  855.079746] run fstests ext4/024 at 2026-03-13 18:47:51 
[  857.441234] EXT4-fs (nvme0n1p1): mounted filesystem 667e4072-1e6f-4c22-bb65-0155564e97b5 r/w with ordered data mode. Quota mode: none. 
[  857.482774] xfs_io (pid 71261) is setting deprecated v1 encryption policy; recommend upgrading to v2. 
[  857.537679] EXT4-fs (nvme0n1p1): unmounting filesystem 667e4072-1e6f-4c22-bb65-0155564e97b5. 
[  858.013188] EXT4-fs (nvme0n1p1): mounted filesystem f0ce627b-e729-4e24-be1c-311bc20e925c r/w with ordered data mode. Quota mode: none. 
[  858.767578] fscrypt: AES-256-CBC-CTS using implementation "cts-cbc-aes-ce" 
[  858.768276] fscrypt: AES-256-XTS using implementation "xts-aes-tegra" 
[  858.822156] fscrypt (nvme0n1p1, inode 1835010): Encryption failed for data unit 0: -115 
[  858.822525] ------------[ cut here ]------------ 
[  858.822825] ext4_bio_write_folio: ret = -115 
[  858.822866] WARNING: crypto/crypto_engine.c:55 at crypto_finalize_request+0x2bc/0x368 [crypto_engine], CPU#1: 15820000.crypto/587 
[  858.823370] fscrypt (nvme0n1p1, inode 1835010): Encryption failed for data unit 0: -115 
[  858.823433] Modules linked in: ext4 
[  858.823838] ext4_bio_write_folio: ret = -115 
[  858.823881]  mbcache jbd2 bnep btusb btrtl rtw88_8822ce rtw88_8822c vfat btintel rtw88_pci btbcm rtw88_core btmtk fat bluetooth mac80211 crc16 cfg80211 tegra194_cpufreq arm_dsu_pmu at24 rfkill tegra_bpmp_thermal fuse loop xfs ina3221 ucsi_ccg tegra_se crypto_engine tegra_drm drm_dp_aux_bus drm_display_helper cec aquantia nvme_tcp 
[  858.824424]  8-page vmalloc region starting at 0xffff80009c6a0000 allocated at copy_process+0x264/0x3e58 
[  858.824571]  mmc_block rpmb_core crc_itu_t nvme nvme_fabrics 
[  858.825681] list_add corruption. prev->next should be next (ffff0000d73a2d00), but was 0000000000000000. (prev=ffff80009c6a6950). 
[  858.826033]  xhci_tegra 
[  858.826910] ------------[ cut here ]------------ 
[  858.831597]  lm90 
[  858.834134] kernel BUG at lib/list_debug.c:32! 
[  858.838686]  nvme_core 
[  858.840859] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP 
[  858.845072]  nvme_keyring 
[  858.847438] Modules linked in: 
[  858.853734]  dwmac_tegra 
[  858.856358]  ext4 
[  858.859509]  stmmac_platform 
[  858.862134]  mbcache 
[  858.864233]  nvme_auth 
[  858.867122]  jbd2 
[  858.869484]  ghash_ce 
[  858.871847]  bnep 
[  858.873946]  stmmac 
[  858.876307]  btusb 
[  858.878409]  hkdf 
[  858.880335]  btrtl 
[  858.882435]  gpio_keys 
[  858.884534]  rtw88_8822ce 
[  858.886547]  pwm_fan 
[  858.888908]  rtw88_8822c 
[  858.891534]  sdhci_tegra 
[  858.893896]  vfat 
[  858.896520]  sdhci_pltfm 
[  858.899058]  btintel 
[  858.900983]  rtc_tegra 
[  858.903608]  rtw88_pci 
[  858.905884]  sdhci 
[  858.908070]  btbcm 
[  858.910434]  pcs_xpcs 
[  858.912533]  rtw88_core 
[  858.914635]  cqhci 
[  858.916996]  btmtk 
[  858.919622]  i2c_tegra_bpmp 
[  858.921634]  fat 
[  858.923732]  phy_tegra_xusb 
[  858.926534]  bluetooth 
[  858.928284]  host1x 
[  858.930997]  mac80211 
[  858.933359]  tegra186_gpc_dma 
[  858.935283]  crc16 
[  858.937646]  mmc_core 
[  858.940621]  cfg80211 
[  858.942634]  spi_tegra114 
[  858.944822]  tegra194_cpufreq 
[  858.947183]  ramoops 
[  858.949546]  arm_dsu_pmu 
[  858.952608]  i2c_tegra 
[  858.954970]  at24 
[  858.957597]  reed_solomon 
[  858.959783]  rfkill 
[  858.961797]  sunrpc 
[  858.964335]  tegra_bpmp_thermal 
[  858.966258]  dm_mirror 
[  858.968272]  fuse 
[  858.971247]  dm_region_hash 
[  858.973609]  loop 
[  858.975708]  dm_log 
[  858.978508]  xfs 
[  858.980522]  dm_mod 
[  858.982533]  ina3221 
[  858.984197]  i2c_dev 
[  858.986210]  ucsi_ccg 
[  858.988484]  nfnetlink 
[  858.990759]  tegra_se 
[  858.993121]  
[  858.995396]  crypto_engine 
[  858.997767] CPU: 1 UID: 0 PID: 587 Comm: 15820000.crypto Kdump: loaded Tainted: G        W           7.0.0-rc3+ #1 PREEMPT(full)  
[  858.999334]  tegra_drm 
[  859.002135] Tainted: [W]=WARN 
[  859.013507]  drm_dp_aux_bus 
[  859.015872] Hardware name: NVIDIA NVIDIA Jetson AGX Orin Developer Kit/Jetson, BIOS 36.5.0-gcid-41890718 08/27/2025 
[  859.018845]  drm_display_helper 
[  859.021560] pstate: 40400009 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--) 
[  859.031797]  cec 
[  859.034947] pc : crypto_finalize_request+0x2bc/0x368 [crypto_engine] 
[  859.041859]  aquantia 
[  859.043609] lr : crypto_finalize_request+0x13c/0x368 [crypto_engine] 
[  859.049996]  nvme_tcp 
[  859.052359] sp : ffff800085ff7b80 
[  859.058484]  mmc_block 
[  859.060845] x29: ffff800085ff7b80 
[  859.064083]  rpmb_core 
[  859.066446]  x28: ffff000105a5f508 
[  859.069684]  crc_itu_t 
[  859.072046]  x27: ffff000105a5f530 
[  859.075459]  nvme 
[  859.077821]  
[  859.081146]  nvme_fabrics 
[  859.083246] x26: ffff80009c6a6960 
[  859.084647]  xhci_tegra 
[  859.087184]  x25: ffff0000d1243010 
[  859.090597]  lm90 
[  859.093221]  x24: ffff80009c6a6930 
[  859.096633]  nvme_core 
[  859.098733]  
[  859.102146]  nvme_keyring 
[  859.104508] x23: 0000000000000000 
[  859.106083]  dwmac_tegra 
[  859.108621]  x22: ffff0000d2f831c0 
[  859.112034]  stmmac_platform 
[  859.114658]  x21: 0000000000000000 
[  859.117810]  nvme_auth 
[  859.120696]  
[  859.124109]  ghash_ce 
[  859.126296] x20: ffff80009c6a6930 
[  859.127783]  stmmac 
[  859.130059]  x19: ffff0000d73a2c80 
[  859.133472]  hkdf 
[  859.135483]  x18: 0000000000000000 
[  859.138896]  gpio_keys 
[  859.140996]  
[  859.144409]  pwm_fan 
[  859.146771] x17: ffffc8ca055808bc 
[  859.148346]  sdhci_tegra 
[  859.150446]  x16: ffffc8ca067031e8 
[  859.153859]  sdhci_pltfm 
[  859.156395]  x15: ffffc8ca0462109c 
[  859.159633]  rtc_tegra 
[  859.162259]  
[  859.165496]  sdhci 
[  859.167859] x14: ffffc8ca046206e4 
[  859.169435]  pcs_xpcs 
[  859.171447]  x13: ffffc8ca03b4e4f0 
[  859.174860]  cqhci 
[  859.177221]  x12: ffff60001ae74598 
[  859.180459]  i2c_tegra_bpmp 
[  859.182558]  
[  859.185972]  phy_tegra_xusb 
[  859.188859] x11: 1fffe0001ae74597 
[  859.190433]  host1x 
[  859.193320]  x10: ffff60001ae74597 
[  859.196559]  tegra186_gpc_dma 
[  859.198658]  x9 : ffffc8ca0670324c 
[  859.201985]  mmc_core 
[  859.205134]  
[  859.208371]  spi_tegra114 
[  859.210733] x8 : ffff800085ff79f0 
[  859.212307]  ramoops 
[  859.214845]  x7 : 0000000000000000 
[  859.218084]  i2c_tegra 
[  859.220359]  x6 : ffff800085ff7b10 
[  859.223684]  reed_solomon 
[  859.226046]  
[  859.229371]  sunrpc 
[  859.231996] x5 : ffff800085ff7a50 
[  859.233571]  dm_mirror 
[  859.235584]  x4 : 1fffe0001a5f0639 
[  859.238909]  dm_region_hash 
[  859.241184]  x3 : 1fffe0001a5f0639 
[  859.244508]  dm_log 
[  859.247396]  
[  859.250722]  dm_mod 
[  859.252820] x2 : 0000000000000000 
[  859.254309]  i2c_dev 
[  859.256320]  x1 : 0000000000000003 
[  859.259646]  nfnetlink 
[  859.261920]  x0 : 0000000000000000 
[  859.265334]  
[  859.267696]  
[  859.270940] CPU: 7 UID: 0 PID: 65459 Comm: kworker/u50:4 Kdump: loaded Tainted: G        W           7.0.0-rc3+ #1 PREEMPT(full)  
[  859.272510] Call trace: 
[  859.274085] Tainted: [W]=WARN 
[  859.285634]  crypto_finalize_request+0x2bc/0x368 [crypto_engine] (P) 
[  859.288084] Hardware name: NVIDIA NVIDIA Jetson AGX Orin Developer Kit/Jetson, BIOS 36.5.0-gcid-41890718 08/27/2025 
[  859.291234]  crypto_finalize_skcipher_request+0x1c/0x30 [crypto_engine] 
[  859.297799] Workqueue: writeback wb_workfn 
[  859.308120]  tegra_aes_do_one_req+0x5ec/0xe40 [tegra_se] 
[  859.314859]  (flush-259:0) 
[  859.319058]  crypto_pump_requests.constprop.0+0x230/0x478 [crypto_engine] 
[  859.324484]  
[  859.327283]  crypto_pump_work+0x1c/0x38 [crypto_engine] 
[  859.333937] pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--) 
[  859.335508]  kthread_worker_fn+0x344/0xdd0 
[  859.340583] pc : __list_add_valid_or_report+0x104/0x180 
[  859.347671]  kthread+0x2ec/0x390 
[  859.351785] lr : __list_add_valid_or_report+0x104/0x180 
[  859.356859]  ret_from_fork+0x10/0x20 
[  859.360096] sp : ffff80009c6a66d0 
[  859.365172] irq event stamp: 174 
[  859.368846] x29: ffff80009c6a66d0 
[  859.372258] hardirqs last  enabled at (173): [<ffffc8ca067032a8>] _raw_spin_unlock_irqrestore+0xc0/0x160 
[  859.375671]  x28: 0000000000000000 
[  859.379082] hardirqs last disabled at (174): [<ffffc8ca066db330>] el1_brk64+0x20/0x58 
[  859.388534]  x27: ffff80009c6a6870 
[  859.391771] softirqs last  enabled at (0): [<ffffc8ca03cd770c>] copy_process+0x115c/0x3e58 
[  859.399470]  
[  859.402796] softirqs last disabled at (0): [<0000000000000000>] 0x0 
[  859.411196] x26: ffff80009c6a68f0 
[  859.412771] ---[ end trace 0000000000000000 ]--- 
[  859.418896]  x25: fffffdffea00ed80 
[  859.423056] Unable to handle kernel execute from non-executable memory at virtual address ffff80009c6a68b0 
[  859.426860]  x24: 00000000ffffff8d 
[  859.426865] x23: ffff0000d73a2d08 x22: 1ffff000138d4d2a x21: ffff80009c6a6950 
[  859.426872] x20: ffff80009c6a6950 x19: ffff0000d73a2d00 x18: ffff0000e7d07ee0 
[  859.426877] x17: 0000000000000000 x16: 0000000000000000 x15: 00000000006f7470 
[  859.426883] x14: 0000000000000000 x13: 736369726261665f x12: ffff6001a8588ae3 
[  859.426889] x11: 1fffe001a8588ae2 x10: ffff6001a8588ae2 x9 : ffffc8ca03eb2250 
[  859.426895] x8 : 00009ffe57a7751e x7 : ffff000d42c45713 x6 : 0000000000000001 
[  859.426901] x5 : ffff000d42c45710 x4 : 1fffe0002a0f2001 x3 : 0000000000000000 
[  859.426907] x2 : 0000000000000000 x1 : ffff000150790000 x0 : 0000000000000075 
[  859.426913] Call trace: 
[  859.426915]  __list_add_valid_or_report+0x104/0x180 (P) 
[  859.426921]  crypto_enqueue_request+0xbc/0x230 
[  859.426930]  crypto_transfer_request.constprop.0+0x6c/0x120 [crypto_engine] 
[  859.430320] KASAN: probably user-memory-access in range [0x00000004e3534580-0x00000004e3534587] 
[  859.439808]  crypto_transfer_skcipher_request_to_engine+0x1c/0x38 [crypto_engine] 
[  859.439816]  tegra_aes_crypt+0x17c/0x308 [tegra_se] 
[  859.443046] Mem abort info: 
[  859.450307]  tegra_aes_encrypt+0x1c/0x28 [tegra_se] 
[  859.450316]  crypto_skcipher_encrypt+0xe0/0x158 
[  859.457490]   ESR = 0x000000008600000f 
[  859.464835]  fscrypt_crypt_data_unit+0x21c/0x2d0 
[  859.472193]   EC = 0x21: IABT (current EL), IL = 32 bits 
[  859.479359]  fscrypt_encrypt_pagecache_blocks+0x1e8/0x350 
[  859.479366]  ext4_bio_write_folio+0x8e4/0x1128 [ext4] 
[  859.486713]   SET = 0, FnV = 0 
[  859.493884]  mpage_submit_folio+0x158/0x1f0 [ext4] 
[  859.501241]   EA = 0, S1PTW = 0 
[  859.503859]  mpage_process_page_bufs+0x1c0/0x560 [ext4] 
[  859.509117]   FSC = 0x0f: level 3 permission fault 
[  859.513571]  mpage_prepare_extent_to_map+0x954/0xf10 [ext4] 
[  859.520492] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000afefb4000 
[  859.529234]  ext4_do_writepages+0x720/0x1558 [ext4] 
[  859.536683] [ffff80009c6a68b0] pgd=10000001084d7403 
[  859.541484]  ext4_writepages+0x198/0x2d0 [ext4] 
[  859.544372] , p4d=10000001084d7403 
[  859.549184]  do_writepages+0x204/0x4c0 
[  859.553734] , pud=10000001084dd403 
[  859.557672]  __writeback_single_inode+0xf4/0x980 
[  859.557680]  writeback_sb_inodes+0x598/0xe38 
[  859.562222] , pmd=1000000138ba0403 
[  859.567557]  wb_writeback+0x17c/0xb68 
[  859.567564]  wb_do_writeback+0x228/0x8e0 
[  859.572899] , pte=00e800011ef66f03 
[  859.578145]  wb_workfn+0x74/0x1b0 
[  859.578151]  process_one_work+0x774/0x12d0 
[  859.581297]  
[  859.586197]  worker_thread+0x434/0xca0 
[  859.586204]  kthread+0x2ec/0x390 
[  859.676873]  ret_from_fork+0x10/0x20 
[  859.679392] Code: aa1303e1 aa1403e3 91050000 97b22a98 (d4210000)  
[  859.685612] SMP: stopping secondary CPUs 
��ERROR:   Unexpected affinity info state. Unhandled Exception from EL0 
x0             = 0xUnhandled Exception in EL3. 
x30            = 0x00000000500009e0 
x0             = 0x0000000000000000 
x1             = 0x00000000500175f8 
x2             = 0x0000000000000000 
x3             = 0x000000005000123c 
x4             = 0x0000000050014f43 
x5             = 0x0000000030cd183b 
x6             = 0x0000000050014f46 
x7             = 0x0000000000000000 
x8             = 0x0000000000000000 
x9             = 0x00000000500001c4 
x10            = 0x0000000050001920 
x11            = 0x0000000000000000 
x12            = 0x0000000000000000 
x13            = 0x0000000000000000 
x14            = 0x0000000000000000 
x15            = 0x0000000000000000 
x16            = 0x0000000000000000 
x17            = 0x0000000050000ca8 
x18            = 0x0000000000000001 
x19            = 0x0000000050000154 
x20            = 0x000000000000000b 
x21            = 0x0000000000000000 
x22            = 0x0000000000000000 
x23            = 0x0000000000000000 
x24            = 0x0000000000000000 
x25            = 0x0000000000000000 
x26            = 0x0000000000000000 
x27            = 0x0000000000000000 
x28            = 0x0000000000000000 
x29            = 0x000000005001adf0 
scr_el3        = 0x0000000000030638 
sctlr_el3      = 0x00000000b0cd183f 
cptr_el3       = 0x0000000000000000 
tcr_el3        = 0x0000000080823518 
daif           = 0x00000000000003c0 
mair_el3       = 0x00000000004404ff 
spsr_el3       = 0x00000000800002cd 
elr_el3        = 0x000000005000123c 
ttbr0_el3      = 0x0000000050025581 
esr_el3        = 0x0000000096000007 
far_el3        = 0x0000000000000000 
spsr_el1       = 0x0000000000000000 
elr_el1        = 0x0000000000000000 
spsr_abt       = 0x0000000000000000 
spsr_und       = 0x0000000000000000 
spsr_irq       = 0x0000000000000000 
spsr_fiq       = 0x0000000000000000 
sctlr_el1      = 0x0000000030d50838 
actlr_el1      = 0x0000000000000000 
cpacr_el1      = 0x0000000000000000 
csselr_el1     = 0x0000000000000000 
sp_el1         = 0x0000000000000000 
esr_el1        = 0x0000000000000000 
ttbr0_el1      = 0x0000000000000000 
ttbr1_el1      = 0x0000000000000000 
mair_el1       = 0x44e048e000098aa4 
amair_el1      = 0x0000000000000000 
tcr_el1        = 0x0000000000000000 
tpidr_el1      = 0x0000000000000000 
tpidr_el0      = 0x0000000000000000 
tpidrro_el0    = 0x0000000000000000 
par_el1        = 0x0000000000000800 
mpidr_el1      = 0x0000000081020300 
afsr0_el1      = 0x0000000000000000 
afsr1_el1      = 0x0000000000000000 
contextidr_el1 = 0x0000000000000000 
vbar_el1       = 0x0000000000000000 
cntp_ctl_el0   = 0x0000000000000000 
cntp_cval_el0  = 0x3f96188777cf8b0f 
cntv_ctl_el0   = 0x0000000000000000 
cntv_cval_el0  = 0x0bec5777baf3e8fa 
cntkctl_el1    = 0x0000000000000002 
sp_el0         = 0x000000005001ade0 
isr_el1        = 0x0000000000000000 
cpuectlr_el1   = 0xa000400b40543000 
gicd_ispendr regs (Offsets 0x200 - 0x278) 
 Offset:			value 
0000000000000200:		0x0000000000000000 
0000000000000204:		0x0000000000000000 
0000000000000208:		0x0000000000000000 
000000000000020c:		0x0000000000000000 
0000000000000210:		0x0000000000000000 
0000000000000214:		0x0000000000000000 
0000000000000218:		0x0000000000000000 
000000000000021c:		0x0000000000000000 
0000000000000220:		0x0000000000000000 
0000000000000224:		0x0000000000000000 
0000000000000228:		0x0000000000000000 
000000000000022c:		0x0000000000000000 
0000000000000230:		0x0000000000000000 
0000000000000234:		0x0000000000000001 
0000000000000238:		0x0000000000000000 
000000000000023c:		0x0000000000000000 
0000000000000240:		0x0000000000000000 
0000000000000244:		0x0000000000000000 
0000000000000248:		0x0000000000000000 
000000000000024c:		0x0000000000000000 
0000000000000250:		0x0000000000000000 
0000000000000254:		0x0000000000000000 
0000000000000258:		0x0000000000000000 
000000000000025c:		0x0000000000000000 
0000000000000260:		0x0000000000000000 
0000000000000264:		0x0000000000000000 
0000000000000268:		0x0000000000000000 
000000000000026c:		0x0000000000000000 
0000000000000270:		0x0000000000000000 
0000000000000274:		0x0000000000000000 
0000000000000278:		0x0000000000000000 
000000000000027c:		0x0000000000000000 �[  860.746815] SMP: failed to stop secondary CPUs 1 
[  860.747870] Starting crashdump kernel... 
[  860.747995] ------------[ cut here ]------------ 
[  860.748125] Some CPUs may be stale, kdump will be unreliable. 
[  860.748294] WARNING: arch/arm64/kernel/machine_kexec.c:174 at machine_kexec+0x60/0x3c0, CPU#7: kworker/u50:4/65459 
[  860.748600] Modules linked in: ext4 mbcache jbd2 bnep btusb btrtl rtw88_8822ce rtw88_8822c vfat btintel rtw88_pci btbcm rtw88_core btmtk fat bluetooth mac80211 crc16 cfg80211 tegra194_cpufreq arm_dsu_pmu at24 rfkill tegra_bpmp_thermal fuse loop xfs ina3221 ucsi_ccg tegra_se crypto_engine tegra_drm drm_dp_aux_bus drm_display_helper cec aquantia nvme_tcp mmc_block rpmb_core crc_itu_t nvme nvme_fabrics xhci_tegra lm90 nvme_core nvme_keyring dwmac_tegra stmmac_platform nvme_auth ghash_ce stmmac hkdf gpio_keys pwm_fan sdhci_tegra sdhci_pltfm rtc_tegra sdhci pcs_xpcs cqhci i2c_tegra_bpmp phy_tegra_xusb host1x tegra186_gpc_dma mmc_core spi_tegra114 ramoops i2c_tegra reed_solomon sunrpc dm_mirror dm_region_hash dm_log dm_mod i2c_dev nfnetlink 
[  860.752483] CPU: 7 UID: 0 PID: 65459 Comm: kworker/u50:4 Kdump: loaded Tainted: G        W           7.0.0-rc3+ #1 PREEMPT(full)  
[  860.761541] Tainted: [W]=WARN 
[  860.764682] Hardware name: NVIDIA NVIDIA Jetson AGX Orin Developer Kit/Jetson, BIOS 36.5.0-gcid-41890718 08/27/2025 
[  860.775191] Workqueue: writeback wb_workfn (flush-259:0) 
[  860.780699] pstate: 604003c9 (nZCv DAIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--) 
[  860.787784] pc : machine_kexec+0x60/0x3c0 
[  860.791981] lr : machine_kexec+0x60/0x3c0 
[  860.796182] sp : ffff80009c6a6210 
[  860.799595] x29: ffff80009c6a6210 x28: ffff000150790000 x27: ffff80009c6a6870 
[  860.806946] x26: ffff80009c6a68f0 x25: ffffc8ca0b839280 x24: ffffc8ca0b839000 
[  860.814298] x23: ffff80009c6a6290 x22: ffffc8ca0b839200 x21: 1ffff000138d4c4a 
[  860.821560] x20: ffff000f8e369000 x19: ffffc8ca06759040 x18: ffff0000e7d07ee0 
[  860.828821] x17: 0000000000000000 x16: 0000000000000000 x15: 0772076e07750720 
[  860.835998] x14: 076507620720076c x13: fffffffffff20120 x12: ffff6001a8588ae3 
[  860.843348] x11: 1fffe001a8588ae2 x10: ffff6001a8588ae2 x9 : ffffc8ca03eb2250 
[  860.850521] x8 : 00009ffe57a7751e x7 : ffff000d42c45713 x6 : 0000000000000001 
[  860.857786] x5 : ffff000d42c45710 x4 : 1fffe0002a0f2001 x3 : dfff800000000000 
[  860.864784] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000150790000 
[  860.872047] Call trace: 
[  860.874495]  machine_kexec+0x60/0x3c0 (P) 
[  860.878696]  __crash_kexec+0x188/0x250 
[  860.882458]  crash_kexec+0x3c/0x58 
[  860.885870]  die+0x120/0x218 
[  860.888581]  bug_brk_handler+0x8c/0x1a0 
[  860.892519]  call_el1_break_hook+0x74/0xd8 
[  860.896546]  do_el1_brk64+0x2c/0x60 
[  860.900220]  el1_brk64+0x38/0x58 
[  860.903456]  el1h_64_sync_handler+0x6c/0xb0 
[  860.907658]  el1h_64_sync+0x80/0x88 
[  860.911157]  __list_add_valid_or_report+0x104/0x180 (P) 
[  860.916234]  crypto_enqueue_request+0xbc/0x230 
[  860.920695]  crypto_transfer_request.constprop.0+0x6c/0x120 [crypto_engine] 
[  860.927609]  crypto_transfer_skcipher_request_to_engine+0x1c/0x38 [crypto_engine] 
[  860.935049]  tegra_aes_crypt+0x17c/0x308 [tegra_se] 
[  860.939682]  tegra_aes_encrypt+0x1c/0x28 [tegra_se] 
[  860.944496]  crypto_skcipher_encrypt+0xe0/0x158 
[  860.949045]  fscrypt_crypt_data_unit+0x21c/0x2d0 
[  860.953771]  fscrypt_encrypt_pagecache_blocks+0x1e8/0x350 
[  860.959195]  ext4_bio_write_folio+0x8e4/0x1128 [ext4] 
[  860.964361]  mpage_submit_folio+0x158/0x1f0 [ext4] 
[  860.968997]  mpage_process_page_bufs+0x1c0/0x560 [ext4] 
[  860.974246]  mpage_prepare_extent_to_map+0x954/0xf10 [ext4] 
[  860.979847]  ext4_do_writepages+0x720/0x1558 [ext4] 
[  860.984833]  ext4_writepages+0x198/0x2d0 [ext4] 
[  860.989558]  do_writepages+0x204/0x4c0 
[  860.993408]  __writeback_single_inode+0xf4/0x980 
[  860.998132]  writeback_sb_inodes+0x598/0xe38 
[  861.002508]  wb_writeback+0x17c/0xb68 
[  861.006094]  wb_do_writeback+0x228/0x8e0 
[  861.010033]  wb_workfn+0x74/0x1b0 
[  861.013357]  process_one_work+0x774/0x12d0 
[  861.017382]  worker_thread+0x434/0xca0 
[  861.021233]  kthread+0x2ec/0x390 
[  861.024645]  ret_from_fork+0x10/0x20 
[  861.028233] irq event stamp: 83680 
[  861.031469] hardirqs last  enabled at (83679): [<ffffc8ca06702760>] _raw_spin_unlock_irq+0x38/0xb0 
[  861.040486] hardirqs last disabled at (83680): [<ffffc8ca06702a08>] _raw_spin_lock_irqsave+0x40/0x100 
[  861.049762] softirqs last  enabled at (83500): [<ffffc8ca03b4fa68>] put_cpu_fpsimd_context+0x18/0x60 
[  861.058688] softirqs last disabled at (83498): [<ffffc8ca03b4fa08>] get_cpu_fpsimd_context+0x18/0x60 
[  861.067613] ---[ end trace 0000000000000000 ]--- 
[  861.072160] Bye! 
[-- MARK -- Fri Mar 13 22:50:00 2026] 


