Return-Path: <linux-fscrypt+bounces-161-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA8C2844F3B
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Feb 2024 03:48:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D0331C23630
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Feb 2024 02:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA0934550;
	Thu,  1 Feb 2024 02:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sr2Zc4jK"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5181DDD7;
	Thu,  1 Feb 2024 02:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706755711; cv=none; b=Yp4dGLAVAquae/hQ+pqdVKzhqcSe33yl+gUhESPND10JB+8z9TmYTwjLpA5pMMb72s6+6HhyKhD+3UsboqH20ng0heyP/5LiK4Lqr3KXUUsRtIqaQjrXqhvnUcR1Y1/7lewkDUtefN3verwYIbGf2FPIkJcDB/OHA8LKiKSmJsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706755711; c=relaxed/simple;
	bh=FN5XfhSsaXvGyUBOUb4XdancJXjLT/ohiZnt1W70K2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tLJnMJpHcnePfehdBGjeaCd37KXfz8XZSrHctgXZaEZFhOMj4nakD1T9lNd4RsigHcGFMd8WQv7V9LzGZQDEeE1iXPR1MSKu+lyFp9CAOKjZqOrutVEm/+sma/wSt9gYR59rmifFNwJyD5cvloMI0/8xax68ON9Kt9irVffdjIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sr2Zc4jK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602FCC433C7;
	Thu,  1 Feb 2024 02:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706755710;
	bh=FN5XfhSsaXvGyUBOUb4XdancJXjLT/ohiZnt1W70K2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sr2Zc4jK/92uPyoJbPenayP+0RoWlz94dkHb49IWpFupUy6i9rQSNS6DRNeODO6yW
	 M0u/ZH9YPcDpQ9bME9wA+tba/OUPAA43a3L9ZGnKqwiq+HEKVoFtl0+8sTEfrUJNL+
	 qH2Hi/h80bCaH6mlplYb/YVWXJRhIqeW+oghvoqChqgCn65tyhJjNRedxB49tlLDVE
	 obFVt0erSYJMWx45oDbPwodV99IyjpfHZQsTRxIEiKEsjzwsFAK7HbVq9wNvzjJdPV
	 OtQ7cIWMXGX44arZyKaZXKTMyWBVXsBCDoDqi6Ps/aTBNst2rmoZ2Sc3N8EaAkcAfy
	 d9PjNvCW2wWfg==
Date: Wed, 31 Jan 2024 18:48:28 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: xiubli@redhat.com
Cc: linux-fscrypt@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
	linux-kernel@vger.kernel.org, idryomov@gmail.com,
	ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
	mchangir@redhat.com
Subject: Re: [PATCH v2] fscrypt: to make sure the inode->i_blkbits is
 correctly set
Message-ID: <20240201024828.GA1526@sol.localdomain>
References: <20240201003525.1788594-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201003525.1788594-1-xiubli@redhat.com>

On Thu, Feb 01, 2024 at 08:35:25AM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The inode->i_blkbits should be already set before calling
> fscrypt_get_encryption_info() and it will use this to setup the
> ci_data_unit_bits later.
> 
> URL: https://tracker.ceph.com/issues/64035
> Signed-off-by: Xiubo Li <xiubli@redhat.com>

Thanks, applied.  I adjusted the commit message to make it clear what the patch
actually does:

commit 5befc19caec93f0088595b4d28baf10658c27a0f
Author: Xiubo Li <xiubli@redhat.com>
Date:   Thu Feb 1 08:35:25 2024 +0800

    fscrypt: explicitly require that inode->i_blkbits be set

    Document that fscrypt_prepare_new_inode() requires inode->i_blkbits to
    be set, and make it WARN if it's not.  This would have made the CephFS
    bug https://tracker.ceph.com/issues/64035 a bit easier to debug.

    Signed-off-by: Xiubo Li <xiubli@redhat.com>
    Link: https://lore.kernel.org/r/20240201003525.1788594-1-xiubli@redhat.com
    Signed-off-by: Eric Biggers <ebiggers@google.com>

