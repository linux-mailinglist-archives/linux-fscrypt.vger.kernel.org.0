Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3500C6ECAE
	for <lists+linux-fscrypt@lfdr.de>; Sat, 20 Jul 2019 01:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732550AbfGSXSq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 19 Jul 2019 19:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728909AbfGSXSq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 19 Jul 2019 19:18:46 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CFC42089C;
        Fri, 19 Jul 2019 23:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563578325;
        bh=+cPl4EVtv/0aF3OZX52a5/3nS5OPpnD6gByRl9g0CR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LXB9bSipNSsFtgpJ2BMAjk9zb5I+lsKtGH9Te/cxyvpuIsCL+yh3Zub7ZCi+thqZU
         eHembG8W+TWYuSNjZ2vo2vGYR1C7qBskLJoZkcEEeY3n6K+oQ4oMUIbF5iIg2+jeDw
         3UXVdMGBRPHKkR1eNDav1qrM5xJ0t2WcqefG2lHE=
Date:   Fri, 19 Jul 2019 16:18:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] e2fsck: check for consistent encryption policies
Message-ID: <20190719231843.GH1422@gmail.com>
Mail-Followup-To: Andreas Dilger <adilger@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
References: <20190718011325.19516-1-ebiggers@kernel.org>
 <621FA6A1-745D-43BA-A52A-4229902737BF@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <621FA6A1-745D-43BA-A52A-4229902737BF@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 17, 2019 at 08:12:25PM -0600, Andreas Dilger wrote:
> It would appear from my reading of the patch that every file that is
> encrypted will have the xattr saved until pass2? If the filesystem is very
> large (eg. billions of files), this will consume a large amount of memory.
> 
> Does it make sense to compare compression xattrs during pass1,
> and only track the set of different
> encryption context/type/master key
> sets that exist in the filesystem?  Since these will typically be common
> among large numbers of files, the memory will be largely reduced,
> maybe one or two ints per inode (either an inode+ID pair for sparse
> inodes, or just an ID for dense range of similarly-encrypted inodes with a
> start+count for the whole range. 
> 
> Cheers, Andreas
> 

That's correct.  I wanted to propose something simpler first to see what people
thought, but yes if this is really a concern, what we should do is assign a u32
id to each new encryption policy that is seen, and store just that id per inode.

To do that we need a proper map data structure for the policy => ID mapping,
which as usual is nontrivial to do in C.  lib/ext2fs/rbtree.h could do, though.
There's also lib/ext2fs/hashmap.c, but it doesn't implement resizing.

- Eric
