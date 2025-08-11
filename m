Return-Path: <linux-fscrypt+bounces-795-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71829B20751
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Aug 2025 13:17:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DEA6E7A7250
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Aug 2025 11:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC4112BEC5F;
	Mon, 11 Aug 2025 11:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="gcppwGYu"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610462C08DF
	for <linux-fscrypt@vger.kernel.org>; Mon, 11 Aug 2025 11:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754910868; cv=none; b=s7uHgz8SDhxVTtwy1mPzwtR25PCTNMl2GiYquDKNrvWvzWHnJCkdyg/Blwo0quVkZ7c9Q/isvFSnw5rutqPNfEw26vDQ5u+kyO9k5Kg4fdLBEs9468qWCx7RGlx0l2YYKY56ejYQg558YiWqW1eH0CDm3/dC7OlJcexYIaalZjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754910868; c=relaxed/simple;
	bh=otpdYSy1ilfGEXWcocGLxg4mSn5osOgKnmShKt0EkyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jHX0950FMlXR1UDK2ZTjOeEaKTypeSWujMe3kvc1TASNhT06wnshoEuhQjemfmMrKBEgX1XLPYdUQJSOltuPC/a9gI1g49B/EL2fwACjGGsUz4CVPyluguIrEU2vk9i2rqeyzQ3FYZY2kz6CBHs43XWObWOIoTeIAOXVY4QiSYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=gcppwGYu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-111-121.bstnma.fios.verizon.net [173.48.111.121])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 57BBDu6B029953
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 07:13:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1754910838; bh=eCERekx2qJbgICEDcQPb6BFVY0/fxG8tnJnx/oSJL5Y=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=gcppwGYuGui0YtwkeJc3OxTfMVHnLyj8Jh2ayVIvazlrORmfq8SYE2nQXClK46QIJ
	 ZC4MvRWdgnmb+9xymUny2kGzBvOpXv44DovveuB6LHwx2tDKwSM+qvnWX1L+1WZtGM
	 sHlkIBeFhaDnjkHqLKKEDm/cDTdrkPzXs+RbdbiXLTxcYkeqjx7BzzVWFMXxGhyhw4
	 D63qXjT2VoccbtPx3dD4W0KJhjvZMLjyy/WZsSax9xtdH2TU8IEqZaf1pUFsRChFPS
	 YaRJ6ZTPNZbn2JHO8qqNSq+z14T0v/9iIeuCk4jZZHW+d2bD47RhcYK55V1j+21s+y
	 OrgeOillPmPnw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 63E212E00D6; Mon, 11 Aug 2025 07:13:56 -0400 (EDT)
Date: Mon, 11 Aug 2025 07:13:56 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, fsverity@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
        linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v5 09/13] ext4: move verity info pointer to fs-specific
 part of inode
Message-ID: <20250811111356.GC984814@mit.edu>
References: <20250810075706.172910-1-ebiggers@kernel.org>
 <20250810075706.172910-10-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250810075706.172910-10-ebiggers@kernel.org>

On Sun, Aug 10, 2025 at 12:57:02AM -0700, Eric Biggers wrote:
> Move the fsverity_info pointer into the filesystem-specific part of the
> inode by adding the field ext4_inode_info::i_verity_info and configuring
> fsverity_operations::inode_info_offs accordingly.
> 
> This is a prerequisite for a later commit that removes
> inode::i_verity_info, saving memory and improving cache efficiency on
> filesystems that don't support fsverity.
> 
> Co-developed-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Acked-by: Theodore Ts'o <tytso@mit.edu>

