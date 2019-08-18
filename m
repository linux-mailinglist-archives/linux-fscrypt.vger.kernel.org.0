Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2837F91984
	for <lists+linux-fscrypt@lfdr.de>; Sun, 18 Aug 2019 22:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfHRUX1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 18 Aug 2019 16:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbfHRUX0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 18 Aug 2019 16:23:26 -0400
Received: from zzz.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0403206BB;
        Sun, 18 Aug 2019 20:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566159806;
        bh=l4MPxofEYLzifGuPs6XDtAT9a/yuc6fcqOwyHG5pdS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kZB/VaSlYYtF6xM0yC8ONXMb46+KVmwjvPGk2hTcqQiL7tLTsMemFe043L6R8sh33
         OhiYdoyy7swXwbQzlYelx0CWvv05WB3Ig+LQPPsj9i4UY6+9ACvkn9nKmRsQLbsfsv
         OL/iuBbbJ4zaURfruZyggkWH9QOKBH2FiCPswni4=
Date:   Sun, 18 Aug 2019 13:23:24 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/6] fs-verity fixups
Message-ID: <20190818202324.GA1824@zzz.localdomain>
Mail-Followup-To: linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <20190811213557.1970-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811213557.1970-1-ebiggers@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Aug 11, 2019 at 02:35:51PM -0700, Eric Biggers wrote:
> A few fixes and cleanups for fs-verity.
> 
> If there are no objections, I'll fold these into the original patches.
> 
> Eric Biggers (6):
>   fs-verity: fix crash on read error in build_merkle_tree_level()
>   ext4: skip truncate when verity in progress in ->write_begin()
>   f2fs: skip truncate when verity in progress in ->write_begin()
>   ext4: remove ext4_bio_encrypted()
>   ext4: fix comment in ext4_end_enable_verity()
>   f2fs: use EFSCORRUPTED in f2fs_get_verity_descriptor()
> 
>  fs/ext4/inode.c    |  7 +++++--
>  fs/ext4/readpage.c |  9 ---------
>  fs/ext4/verity.c   |  2 +-
>  fs/f2fs/data.c     |  2 +-
>  fs/f2fs/verity.c   |  2 +-
>  fs/verity/enable.c | 24 ++++++++++++++++--------
>  6 files changed, 24 insertions(+), 22 deletions(-)
> 
> -- 
> 2.22.0
> 

I've gone ahead and folded in these fixes.

- Eric
