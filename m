Return-Path: <linux-fscrypt+bounces-1554-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wCR8IcFZ6WndXwIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1554-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Apr 2026 01:29:05 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D9144B899
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Apr 2026 01:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8CA14300AB2F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Apr 2026 23:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B423A3E69;
	Wed, 22 Apr 2026 23:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SekkEjDh"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FF63A3833;
	Wed, 22 Apr 2026 23:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900543; cv=none; b=afOjxqh6h1cjc5spsiXXavfaKhnWhXyyCYztgUrjY0c7WWLfiHV6TZgFRo516mhy59vRKVWB4zinuWIFJyT0UbKk3jY+7cOodC7T2cMQ4BNIcC/l6B/b0TL6Hl7p8au2wer1szMic+zbuLujOCh9SBka0J3ziK6IZE3lciwcIPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900543; c=relaxed/simple;
	bh=bvl92UEOxoPlURu3laZ0+Grpbq+E+dKoVy+MV3iNcMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lC6WRhVFQXDFCR/AhdEVCN5B+Fzr+mjiF3x5erVZMFR1bFCqoWOnJRdNwGjUTbvnThlVptCcNRRFjIn4mcp6IFtefZt080Jml8Vgz4L7E51L7j6PIR/oTdHiXg7W5KO8seoq3OkFxyXDihQUBIaeK1lja18/uQvly5bocg1/THo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SekkEjDh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC915C19425;
	Wed, 22 Apr 2026 23:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900543;
	bh=bvl92UEOxoPlURu3laZ0+Grpbq+E+dKoVy+MV3iNcMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SekkEjDhHV8mJkGXxThm7jzjXl5r+G21rFwehhvUlC8Rt0thUJXkQ9ZvnLJDA49bN
	 AiEWsPZKrWpwJl6zfPjMan6ZQQZ0SAX+GPqfqhIpTcP35W8c1hY1j5dB6ZIVRdWyZA
	 RNZviU5piCS25/nr/hQI6ts3ddvXVIovvSSX1VqyN4YbVGTBHe3cWBWDtY95rWDwN0
	 xHHWA5ihxTGxv+YwxpMRqQ876Ka0u7IW76BymiTC5SP9o3smEjBbRycPC8NcfOLvHb
	 0Z8M9tfGW58T0LF6vlXrNkCURDjmm/8i26jOGnEaqiBhh7H6sdLRr3wu5y+atVFtu1
	 3x/J7bLZeZD7Q==
Date: Wed, 22 Apr 2026 16:27:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
Cc: tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: add software key support for filesystem-managed
 data
Message-ID: <20260422232747.GD2226@sol>
References: <20260421075717.170840-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421075717.170840-1-liaoyuanhong@vivo.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1554-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,vivo.com:email]
X-Rspamd-Queue-Id: 27D9144B899
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Apr 21, 2026 at 03:57:17PM +0800, LiaoYuanhong-vivo wrote:
> Some filesystems store small file contents in filesystem-managed regions
> rather than in regular data blocks submitted through bios. One example is
> F2FS inline_data, where the payload is stored inside the inode node block.
> Such regions still need to follow the inode's fscrypt contents encryption
> semantics, but they cannot rely on blk-crypto because they are not
> submitted as standalone file data bios.
> 
> As a result, when blk-crypto is enabled, mechanisms such as inline_data are
> typically disabled outright. However, it is desirable to re-enable such
> space-saving features while still preserving the required encryption
> semantics.
> 
> To support this, add fscrypt_crypt_fs_layer_page_inplace(), a helper that
> encrypts or decrypts a caller-provided page region in place using
> filesystem-layer software crypto and the inode's contents encryption
> policy.
> 
> This support is limited to v2 encryption policies. v1 policies do not
> provide the key setup model used here, so this path returns -EOPNOTSUPP for
> v1. Hardware-wrapped keys are not supported either, since deriving a
> software skcipher key requires software-accessible key material, which
> conflicts with the hardware-wrapped key model.
> 
> When the inode's normal contents path uses blk-crypto, fscrypt may not have
> a software skcipher key prepared for the inode contents key. Add an
> optional filesystem-layer prepared key to fscrypt_inode_info. This key is
> derived using the same v2 contents-encryption KDF as the normal contents
> key, but is prepared as a software skcipher key and is used only by the new
> filesystem-layer helper.
> 
> Signed-off-by: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>

I don't have time for a super detailed review at the moment, but here
are my initial thoughts:

- This needs to be sent along with the code that actually uses it in
  ext4 and f2fs.  Please also Cc the mailing lists for those
  filesystems.

- This is going to require an "incompat" filesystem feature flag.  After
  all, once a filesystem contains files that use this scheme, older
  kernels won't understand it.

- UBIFS and CephFS already use fs/crypto/ but don't support blk-crypto
  (inline encryption).  This new code feels duplicative of that.  It
  should be possible to reuse the existing code instead.  That would
  include, for example, reusing the existing en/decryption functions and
  the existing struct ci_enc_key field.  This would keep the changes
  limited mainly to how the key is being set up.

- Supporting all the different IV generation methods doesn't make sense
  when a per-file key is always used.

- The fact that this is incompatible with hardware-wrapped keys greatly
  limits the usefulness of this.  (Note that technically, it could be
  supported in combination with them anyway.  But the security models
  would be inconsistent, which I assume is what you have in mind.)

Hope this is helpful,

- Eric

