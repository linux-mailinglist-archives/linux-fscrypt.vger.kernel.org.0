Return-Path: <linux-fscrypt+bounces-1639-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 3c7mFf1UMGrIRgUAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1639-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jun 2026 21:39:41 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A42EC6897D8
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jun 2026 21:39:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mR7l6UIz;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1639-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1639-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D58BE313DC60
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jun 2026 19:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44ED13B47D9;
	Mon, 15 Jun 2026 19:37:33 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B453B19BB;
	Mon, 15 Jun 2026 19:37:29 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781552253; cv=none; b=XMrHDjcbEJFtuloE8AQG1XKw9qq4bsCizWsBiU7iM6LqvrtKpSsguku3sXRVMvziSHN12xCQ+3LF2TmmVG7LTWTKY2I2I7XBsvOYID46GwIUprT7wh4saN96vhe78M2bxhqbtzUiNLHg7ClYK5khDOAdYtWDEWtlCiMvaPadokM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781552253; c=relaxed/simple;
	bh=/iUo4EqGSX3HqetKGl2xjPAsPs1LVfixXNW/oyoAzF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AG6X0v7eK6nG0MznN7yKaDSdiwf2dBVSjtMlzbkv5/HfTlpauAHrRuVvumnVYfFAH7MSV+yF/0Dw0/3/E/f3KJsiVRnCCi7JcvjN51ReaOVjDfEyLc3NRVcz5TckRTyF3TP8neUBDUYs6Hqk0Gx7MuS7N2WZrfn9r/aKLVdL5K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mR7l6UIz; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517DE1F00A3D;
	Mon, 15 Jun 2026 19:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781552249;
	bh=xzdaAZ3vb4ixL+pONGkgMZtFCmR6/l4XZZFEzZGSXuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mR7l6UIzq1yljDBgRBwGWbw5sYLRrGC/WtvkE6SS1PAidXXsnZEn+S63G5twdMRi1
	 tkMAhkksazmcTnUO3XTiSRoX0qPLh6tVMghb0F8gWQQ6+rYsRxv+/UDr3lzVHGJziJ
	 CdNU4fXWHatiGntbD6Ged4oN1G0fNn+NiepqyRX1IuTpY17MoC0P7JprMR3gVOECH1
	 dIt5Lx38vRPQO8QQAAD+g7sqyRpMwT4mEMV+C1iHo2hN/LDHEhSWpTB5HqA9ny+4NB
	 OIw6nzUQQSzF65/Qid/VMmOxJ6dlPsniJriBQdC1VnhZFR5so2royamQRNAchAGqik
	 NNtZ7gYGvC75w==
Date: Mon, 15 Jun 2026 12:37:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	"open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	"open list:FSCRYPT: FILE SYSTEM LEVEL ENCRYPTION SUPPORT" <linux-fscrypt@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 0/3] f2fs: support encrypted inline data
Message-ID: <20260615193728.GA1764@quark>
References: <20260615125517.362294-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615125517.362294-1-liaoyuanhong@vivo.com>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:liaoyuanhong@vivo.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:corbet@lwn.net,m:skhan@linuxfoundation.org,m:tytso@mit.edu,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-kernel@vger.kernel.org,m:linux-doc@vger.kernel.org,m:linux-fscrypt@vger.kernel.org,m:linux-ext4@vger.kernel.org,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-1639-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,quark:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A42EC6897D8

[+Cc linux-ext4@vger.kernel.org]

On Mon, Jun 15, 2026 at 08:55:12PM +0800, LiaoYuanhong-vivo wrote:
> F2FS currently disables inline data for encrypted regular files because the
> inline payload is stored in the inode block and does not go through the
> regular bio-based fscrypt path.  This wastes space for small encrypted
> files on Android devices using F2FS inlinecrypt.
> 
> This series adds an encrypted_inline_data on-disk feature for F2FS.
> With this feature enabled, encrypted regular files may keep small contents
> in the inode block.  The inline payload is encrypted before being stored in
> the inode and decrypted back into page-cache plaintext on read.
> 
> The fscrypt changes are scoped to filesystem-managed data-unit crypto.
> F2FS first asks fscrypt whether the inode's key/policy supports this path.
> It prepares the software transform only when encrypted inline payloads are
> read or written.  Inlinecrypt support is limited to v2 IV_INO_LBLK_64 and
> IV_INO_LBLK_32 policies, including the hardware-wrapped key configurations
> supported by fscrypt.  Per-file inlinecrypt keys and DIRECT_KEY policies
> are not supported for encrypted inline data.

I still think we should hold off on this, for the reasons I gave at
https://lore.kernel.org/r/20260515184124.GA4903@quark/

As soon as you start using hardware-wrapped keys this will become
irrelevant, as it can't be used in that case.  I see you added "support"
for that case anyway by deriving contents encryption keys from the
sw_secret.  But that bypasses the security model, which isn't okay.

I'm also working to simplify ext4 and f2fs's file contents encryption
implementation by standardizing on blk-crypto.  That aligns well with
what btrfs encryption is going to do as well.  So this isn't a great
time to be making f2fs's file contents encryption implementation even
more complex by going in a different direction.

If there was demand for this feature from the ext4 side for
general-purpose Linux distros as well, that would make it a bit more
appealing, as it would show broader demand.  But with the proposal being
f2fs-specific and effectively just for Android devices that *don't* use
wrapped keys, that feels too narrow for the added complexity.

This proposal also lacks test cases in xfstests and/or Android's
vts_kernel_encryption_test that verify that the inline data is actually
being encrypted correctly.  Those tests are essential, and we *must not*
add new file contents encryption implementations without such tests.

- Eric

