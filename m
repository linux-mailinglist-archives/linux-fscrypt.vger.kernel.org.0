Return-Path: <linux-fscrypt+bounces-1739-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Qi63B2C8Smq/GwEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1739-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 22:19:44 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F1B670B4F0
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 22:19:43 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIga6IiU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1739-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1739-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1D0903008990
	for <lists+linux-fscrypt@lfdr.de>; Sun,  5 Jul 2026 20:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB062F7F0D;
	Sun,  5 Jul 2026 20:19:40 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C693D1DB356;
	Sun,  5 Jul 2026 20:19:39 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783282780; cv=none; b=DpWCtBfzUQ1wg0oFllPghMP+QIY2G8YeQRoS3CYPVexMZHDYufYpY11Ve0WAAXrP/O/BzrRnCP7rpVEC98/dg/wdFA897urH6Jk1JsUX91dsfKSlu7335lPz2hiN6wXcjmrvwQ2rOVejgHOCO7IAD0TCQ3zhU/3W1WP1k8p2D6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783282780; c=relaxed/simple;
	bh=C+fsI4WqE9szuOT5sOuPWlSE4R6UTpi/CGbSJIuG/rY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPqMTJxuBiH2UMZPyHbXLjIDnoc2xO735Bm8oLhSLCPlT5L0JT6mljQS5BoOiHuFoswZP+SxhIfdHAm6TlLaZSg7bCSwh0W3Ncza6SBvySO0xISRMltOaOHNGXFY47p7Dq7fjUVkz+2//cV6zhv0YcMogKA21G6mwwIeOhJGty8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZIga6IiU; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B011F000E9;
	Sun,  5 Jul 2026 20:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783282779;
	bh=ut7iHQF/AbxXgauDKV+8ArFS+YsvVMBn1LLgz1WNd1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZIga6IiUpJDUov9sJrPSs0xrW+7w/Lo594hWKveoTRiueAcCmhDHGWuoNhKW9m4s7
	 KEgUnSAZ12+Ucc+thyl9NcQvL08y8NNwmOh7id67QWB8dePRqmD7kN7kcwq+niA2vn
	 dPYO6X+jHzrdGsiugS9gXZ4RHea27n/AGJxRUdsmKgKF6CcgiGb4/m3+N7/Bk8CcDG
	 F7yt2a/iTpdVSBl099lqGKINf5Iqg7enT+AZGz9UR3Du9wPVx+6MWV26Du56BgqXxB
	 GuY4szfcpBZ3nW8mM9G9a5Q7V7CeHJEypgl31f5Gvdypblqk+0aANDO6HwishVmZFJ
	 T9RwWKuveNRWA==
Date: Sun, 5 Jul 2026 13:19:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v2 13/17] fscrypt: Remove fscrypt_dio_supported()
Message-ID: <20260705201937.GI41916@quark>
References: <20260705194555.75030-1-ebiggers@kernel.org>
 <20260705194555.75030-14-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705194555.75030-14-ebiggers@kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-block@vger.kernel.org,m:hch@lst.de,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:jack@suse.cz,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:riteshlist@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1739-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.sourceforge.net,lst.de,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,quark:mid,lst.de:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9F1B670B4F0

On Sun, Jul 05, 2026 at 12:45:50PM -0700, Eric Biggers wrote:
> On block-based filesystems, fscrypt file contents encryption is now
> always implemented using blk-crypto.  This implementation supports
> direct I/O.
> 
> Therefore, fscrypt_dio_supported() now always returns true, except in
> the edge case where statx(STATX_DIOALIGN) is called on an encrypted
> regular file that hasn't had its key set up.  But that was really a
> workaround rather than the desired behavior, so we can disregard it.
> 
> Thus, fscrypt_dio_supported() is no longer needed.  Remove it.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Sashiko pointed out that the following comment in ext4_getattr() (and
also in f2fs_getattr()) becomes outdated and should be updated too:

/*
 * Return the DIO alignment restrictions if requested.  We only return   
 * this information when requested, since on encrypted files it might    
 * take a fair bit of work to get if the file wasn't opened recently.    
 */

- Eric

