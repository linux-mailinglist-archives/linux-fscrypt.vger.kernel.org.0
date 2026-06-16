Return-Path: <linux-fscrypt+bounces-1641-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id yD3UFf3VMWrLqwUAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1641-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Jun 2026 01:02:21 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CD98695A8D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Jun 2026 01:02:20 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UiXgzW7o;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1641-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1641-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6EC1A3081A72
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Jun 2026 23:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1120948033A;
	Tue, 16 Jun 2026 23:02:19 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D9B2D12EC;
	Tue, 16 Jun 2026 23:02:17 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781650938; cv=none; b=moBhYf27SrAkl5DUF0QrmxCpWXAm2mlszhlcNzKXV+EMGWCc3/XM20lg4kn4+xUPfIyPwc/23rkAUiPSSD0IkvDxWqTiEEuh4EiBr5eIdXkGcV0vLocc6NCETAZ4hrz3Hbov5w0AE01u4+P5jPE31guSvJbaF16G34uF4PsmnRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781650938; c=relaxed/simple;
	bh=Dq2XvKfdYhSbvZxkXcwcL7/IoWIBOMEcHJflP3/VUWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eB/46qxrMJvCEV7vwfaA5J0g9nrSIg+FgyVp2aSmQDxH+jrrLBYmYQClAJVEAyWAf3pKAWJPblGYh6M5dc8Zq3Pzmi0I49x2KZ/HI2RtmOEtSBYLN3dIhmK3IBriqSfhV1hh7rE/kAZ+/N5iyrmnXyA3buCPxPDDRT6WmfY3s3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UiXgzW7o; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AF71F000E9;
	Tue, 16 Jun 2026 23:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781650937;
	bh=ALycoJqF47JiSW3q3qosjWMWmgc4Rn8LlDIDcPMChlY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UiXgzW7oJNp5oLHQKJ+Gv76OvpIPe8p65skAe0t9XSOL1cp39mb+FBktdJzMe4adZ
	 WyeS9jMjNt0JXod4D1pdLs+el05lNXdpqmbq1OaAwdax0uwpGy51feTDK0YxyHMp3+
	 xsE5MurJ4YYrePYXaiTgY0ApjU5KX9/Ts1LTERPAOcvKW/Ag8c9aP7MuRf0oPx19DW
	 NQpHR2qrvunvGzI/1Vd2XfQl3tI82+QD39dRBxAWNjUFrTjfWUJzpezsx5tzS0Sgoz
	 phE0PvPHxbC3DVPDhs699/3Zan6/0cDsBVpJ11iA6lgAFzILlc9I76mTpqOkLtRxh5
	 +s+L4S8Nk66TQ==
Date: Tue, 16 Jun 2026 16:02:15 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
Cc: chao@kernel.org, corbet@lwn.net, jaegeuk@kernel.org,
	linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, tytso@mit.edu
Subject: Re: [PATCH v3 0/3] f2fs: support encrypted inline data
Message-ID: <20260616230215.GA1873@quark>
References: <20260615193728.GA1764@quark>
 <20260616094612.45505-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616094612.45505-1-liaoyuanhong@vivo.com>
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
	FORGED_RECIPIENTS(0.00)[m:liaoyuanhong@vivo.com,m:chao@kernel.org,m:corbet@lwn.net,m:jaegeuk@kernel.org,m:linux-doc@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-fscrypt@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:skhan@linuxfoundation.org,m:tytso@mit.edu,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-1641-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,quark:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9CD98695A8D

On Tue, Jun 16, 2026 at 05:46:12PM +0800, LiaoYuanhong-vivo wrote:
> Could you share more about the direction you have in mind for simplifying
> f2fs/ext4 contents encryption around blk-crypto?

Currently ext4 and f2fs each have two implementations of file contents
encryption and decryption:

- One where the en/decryption is done in the filesystem layer

- One where the filesystem attaches a bio_crypt_ctx to the bios and the
  en/decryption is done either in the block layer by blk-crypto-fallback
  or by inline encryption hardware

I'd like to drop the first one, for simplicity and to reduce the burden
on ongoing developments like large folio support.

> For f2fs inline_data, there is still a real space-saving benefit on phones,
> since many encrypted files are smaller than 4K. Is there any acceptable
> future direction to support this kind of inode-resident data with
> blk-crypto or hardware-wrapped keys?

It is incompatible with inline encryption hardware.  A CPU-based
solution like Intel Key Locker or RISC-V High Assurance Cryptography
could provide similar security properties.  But there's nothing for
arm64 yet.  And I should mention that no one has wanted to use Key
Locker anyway because it's really slow.

- Eric

