Return-Path: <linux-fscrypt+bounces-1604-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BPPF7NpB2pA2QIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1604-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 May 2026 20:45:07 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9955556738
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 May 2026 20:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E1A5B300A389
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 May 2026 18:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA1633FDC19;
	Fri, 15 May 2026 18:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQAgJ68J"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8951C23A99F;
	Fri, 15 May 2026 18:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778870494; cv=none; b=sUbmqVX3QbrVv4pkzi7FQMwhllA5GCZDvnDUEAmxqI17udwbRZxLe/CLWT32Qb3t9C8X2B+N0bOXp5ZGaIMjbjzj9if9/krQ3Tqv8ask7NgtVcBfxMiWDKD1XZpP+WtIwpPTuN0BN1uNqbsXFrSiYBSam820rUl2zK6PuJah3x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778870494; c=relaxed/simple;
	bh=GwivGZO8Wm6h0va9M4mOP/dflJKHX49qqSGVDT/xeJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ki3iqE867ZUwJOdUD1p5EXhBLTSykrOZdK+pSMIKTqb4MLQoqAfzSBMh5llZSy/RG0URHFO0xaO4oteqFkaWDxBU9QQnRWxqLI3jq7B/SSXU1X4/Cd0FmVhyRYOD1zgsxrRhozd7ahhBb4gMSjBAf85IXTHF4CMR/OnrE2vQK4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQAgJ68J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144C5C2BCB0;
	Fri, 15 May 2026 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778870492;
	bh=GwivGZO8Wm6h0va9M4mOP/dflJKHX49qqSGVDT/xeJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dQAgJ68JBJiEVYcWN4KUfoFOjI43S8lEmAduuVLNtLsWgJCkCJUESQKxYZzxS4FPG
	 6r4b0sekFeMfqq6CecYHs/3GGSFY11ojQC5SPUUX48cjQDLvPKcA6RggznQ5UIw378
	 gkBEh8QdYrxHdqGBC7FENxInFyJNa07gtI5npZhFWAZ+ZOOAHSIh6dsnoK4DRayLb9
	 xc6guYJ30CVzhDg9jk5AYfWOfo1iH5P4jT21xVAP03kLnMQ64oxvS9KnvsYN2sy7Mi
	 aPVkBTySkovP47fajmYy7NH2X/xnGPIY/wGLqXeRZMK1PNEBcXiPJqO9kmrFkftM7r
	 oY58+9YIUJLlA==
Date: Fri, 15 May 2026 11:41:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	"open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	"open list:FSCRYPT: FILE SYSTEM LEVEL ENCRYPTION SUPPORT" <linux-fscrypt@vger.kernel.org>
Subject: Re: [PATCH 0/3] f2fs: support encrypted inline data
Message-ID: <20260515184124.GA4903@quark>
References: <20260513100431.299904-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513100431.299904-1-liaoyuanhong@vivo.com>
X-Rspamd-Queue-Id: B9955556738
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1604-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vivo.com:email,sashiko.dev:url]
X-Rspamd-Action: no action

On Wed, May 13, 2026 at 06:04:27PM +0800, LiaoYuanhong-vivo wrote:
> From: Liao Yuanhong <liaoyuanhong@vivo.com>
> 
> F2FS currently avoids inline data for encrypted regular files.  This is
> because inline data is stored in the inode block, outside the regular
> bio-based data path where fscrypt and blk-crypto normally operate.
> As a result, devices that enable blk-crypto for encrypted file contents
> cannot use F2FS inline data for encrypted regular files, which wastes
> space for small files.
> 
> This series adds support for keeping small encrypted regular-file
> contents as inline data.  The f2fs side defines a new on-disk feature,
> encrypted_inline_data, under which inline payloads of encrypted regular
> files are interpreted as ciphertext.  The payload is encrypted before
> being stored in the inode block and decrypted back into page-cache
> plaintext on read.
> 
> The fscrypt side prepares a software contents-key transform even when
> normal file contents use blk-crypto, so filesystems can encrypt
> filesystem-managed data regions that do not go through bio submission.
> The new fscrypt helper operates on fscrypt data units and leaves the
> filesystem responsible for deciding which filesystem-managed byte ranges
> need this treatment.
> 
> The software crypto operation is limited to the inline payload.  Since
> these files are small enough to remain inline, the expected read/write
> performance difference between hardware and software crypto is small,
> while the space saving from keeping the data inline is significant.
> 
> The feature is guarded by CONFIG_F2FS_FS_ENCRYPTED_INLINE_DATA and by the
> F2FS encrypted_inline_data on-disk feature bit.  Filesystems with this
> feature set are rejected if the kernel lacks the config option.
> 
> Hardware-wrapped keys are not supported by this initial version. I would
> like to discuss whether this feature should remain disabled for
> hardware-wrapped keys, or whether there is an acceptable way to support the
> combination in the future.
> 
> The f2fs-tools support for formatting filesystems with this feature will be
> submitted separately.
> 
> Basic testing passed.  Encrypted small files can be kept as inline data,
> and read/write verification succeeded.

Honestly, I'm not convinced this is worth the complexity and the
additional memory use.

First, it works only in the combination: 'f2fs && inlinecrypt &&
!hw_wrapped_keys'.  That really limits how many users would use this.
'f2fs && inlinecrypt' de facto targets it to Android devices rather than
"regular" Linux systems.  But at the same time, the "best practice" on
such devices is to use HW-wrapped keys, which has already been widely
adopted.  So this would be useful only on devices where the SoC doesn't
support HW-wrapped keys.  Its usefulness will go away when support for
HW-wrapped keys is added.

Second, in the per-file key case this makes every file use an additional
1 KiB of memory or so (assuming AES-XTS) to hold the "software key",
just in case the file ever has inline data.  That seems problematic, and
maybe not a great direction to be going in right now, given the ongoing
RAM shortage.

There also seem to be quite a few bugs/issues.  Sashiko found quite a
few
(https://sashiko.dev/#/message/20260513100431.299904-1-liaoyuanhong%40vivo.com).
But just from a quick readthrough, anything that calls
fscrypt_is_key_prepared() seems to be broken now, as that function isn't
aware that both fields of fscrypt_prepared_key can be needed.

I'm also not seeing what differentiates the new
fscrypt_{en,decrypt}_data_unit_inplace() from the existing
fscrypt_{en,decrypt}_block_inplace().  They seem redundant.

There's already a lot of complexity in fscrypt, with the different
settings and the different ways the filesystems do en/decryption.  With
this, plus the concurrent work to add support for extent-based
encryption (for btrfs), it's really quite hard to keep track of
everything.  So I have to wonder if this patchset is really worth it.

So, overall, I think this would need a bit more work.  But also I'm
wondering if it's actually worthwhile.  Do you plan to never enable
HW-wrapped keys, for example?  And you're fine with using more RAM?

- Eric

