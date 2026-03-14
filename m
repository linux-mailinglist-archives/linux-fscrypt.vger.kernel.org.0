Return-Path: <linux-fscrypt+bounces-1531-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MIX2HGWVtWnL2AAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1531-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Mar 2026 18:05:41 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C6D9F28E0E3
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Mar 2026 18:05:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC63C30221E8
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Mar 2026 17:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFA931B130;
	Sat, 14 Mar 2026 17:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUdKMyoI"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D5330C637;
	Sat, 14 Mar 2026 17:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773507903; cv=none; b=Zy5HyMjlNWsQyxJH0EfXvw3soJ+NHsPpJML1l64osI2KI8PVmivvD9g2A2Ke+BjjAr6rVxdgVgDoIAeF0QT+CpFPB5BviIYN/wWvKDFEorkTnG9L/AmSUrmOOTxLlz2q/aGr3mTHARxnB76LfeQBqu8fnbmApAVusbx5G9cHoTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773507903; c=relaxed/simple;
	bh=tJyR9j4I3vHMBqOaF8d+dyqmpYb2pUbvSIOBTu/CoDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RdVoPdENb9OYQBSKQUgRrXQ0j7V0HdWw0jCos7v1BmABTLoOmS63lKfjg1EXV0PtHTtsxCYBh7yZ6ZhmVBhZAn76f5utfY/kSw+gJR0QjnqNdsUE6yw3707kizHdnLyjj0aBLY9FTFFCa8AfvSiYw7rwUT1cU3tnazcPOpil46I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUdKMyoI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BDDC116C6;
	Sat, 14 Mar 2026 17:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773507903;
	bh=tJyR9j4I3vHMBqOaF8d+dyqmpYb2pUbvSIOBTu/CoDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JUdKMyoIR5kFfWMkpoeJgby/EM3j02c1cnZ2/vNFwPjHR2oi/x5Q2N9DEVeoJXWjm
	 J2l960qZkiCHsA0LHbUg6XDm2+5W1iiNVsJtYADuX4ifjeyM9jELDh0aPX6o6zK+dR
	 FvbfSLzGeEcDRE+oBPLNo6ymCzT9YpaBQper9BoTbJnsBmPaIv0YzfzBO8KCtcF8by
	 dB7nHKM3U6rCns0NCzuyxT1P6XBVotcsWO/+qwRNswbuwHeTYyPxhDLb7QkuFlujFP
	 Xaqehf9AgwXVGAfIeQK7rxYAWnMattqHO0eMexkM4g4bkgwxe1p9ST5EghObGuwVzC
	 4QAQi8bQ/YMKA==
Date: Sat, 14 Mar 2026 10:04:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [Bug report][xfstests ext4/024 crash on ext4&fscrypt] kernel BUG
 at lib/list_debug.c:32!
Message-ID: <20260314170434.GA8675@quark>
References: <20260314080937.pghb4aa7d4je3mhh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314080937.pghb4aa7d4je3mhh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1531-lists,linux-fscrypt=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	SUBJECT_ENDS_EXCLAIM(0.00)[]
X-Rspamd-Queue-Id: C6D9F28E0E3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, Mar 14, 2026 at 04:09:37PM +0800, Zorro Lang wrote:
> [  859.430320] KASAN: probably user-memory-access in range [0x00000004e3534580-0x00000004e3534587] 
> [  859.439808]  crypto_transfer_skcipher_request_to_engine+0x1c/0x38 [crypto_engine] 
> [  859.439816]  tegra_aes_crypt+0x17c/0x308 [tegra_se] 
> [  859.443046] Mem abort info: 
> [  859.450307]  tegra_aes_encrypt+0x1c/0x28 [tegra_se] 
> [  859.450316]  crypto_skcipher_encrypt+0xe0/0x158 
> [  859.457490]   ESR = 0x000000008600000f 
> [  859.464835]  fscrypt_crypt_data_unit+0x21c/0x2d0 
> [  859.472193]   EC = 0x21: IABT (current EL), IL = 32 bits 
> [  859.479359]  fscrypt_encrypt_pagecache_blocks+0x1e8/0x350 
> [  859.479366]  ext4_bio_write_folio+0x8e4/0x1128 [ext4] 

Thanks.  fscrypt isn't supposed to be using the tegra crypto driver.
But that driver is actually so broken that it doesn't even set its flags
correctly, causing the crypto_skcipher API to select it anyway.
https://lore.kernel.org/linux-fscrypt/20260314165515.9678-1-ebiggers@kernel.org/
fixes this by making the driver set the correct flags.

I'm looking forward to lib/crypto/ offering all the algorithms that
fscrypt needs so that we don't have to use crypto_skcipher.

- Eric

