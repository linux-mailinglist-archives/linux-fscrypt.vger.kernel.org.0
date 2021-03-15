Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BDE33C9E1
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Mar 2021 00:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhCOX3l (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Mar 2021 19:29:41 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:56001 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229748AbhCOX3l (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Mar 2021 19:29:41 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 44327274E;
        Mon, 15 Mar 2021 19:29:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 15 Mar 2021 19:29:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=gtMU2ckSEJiEpIL2ztF/wl21X3j
        gBeF6hQz6ReSaJ5I=; b=frQpSHnEL3QwJkkPnHlfU/xjsej+vgG+yjON2LT+qm8
        ZVJ9GGyKAxjLf0utZg7FJPGP7sPnRvx/RoVxFZ1QUgrSPW2L6lJi98atucJcfBpG
        1L4ppnLChlOY+PSFIF1NBCJcAOybvSqScQOFgreYsrcgK5wqT9FQtN3Xm8pLdAkN
        NemA+hp9PcxdZREdA5tiYTy9xH2+2qRaEVIF3N8evfAxggUjTmjSjGU/RZA+TqhC
        TNKO+qsLFTZRpl0wE9N8ixHtXBwdtvMCfjKZd7c3CYf/UQi/H65S6lxHDbVhneZm
        +CrUAFXQYa0iUl7EiMCJVs9WGda75z5D7UUF6svbPzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gtMU2c
        kSEJiEpIL2ztF/wl21X3jgBeF6hQz6ReSaJ5I=; b=GS1vSSUGDYKhKIVgGylwHs
        RA8b5JEVyNKUPO4kmrSTnkN1qcPINZv+rcWoJ/C9G7wLpRbaZpkSrQzRMd/NOHqH
        9iMNSnnEYu2mSJKq+dmFsLPB1fjca3yYMCgkd5XIyGxmh6RzRYqB5s08FxQn2aLK
        XG9UQfLzNkPQV74tywt0EQ265RJx3p5b9Rl4k/LDW1vkGCLVRT84K593/dZ6mNTD
        C7vnISeC7Ps6a/5Z1FzxtI5yZBmc5ev2UDiMVsvU8CCEwjfksZc2BM+F3OC4WAr6
        B7ePTKkxFXSP4+E41VB8R6NTJBiFHtc4FvV47A4Cv4prUdq0Ei3pwnCYOa3oHujg
        ==
X-ME-Sender: <xms:4-1PYG9f8ks1uhrSETH_dza1veAp51PZEHexxYJgDPA-RRvpkmTyIg>
    <xme:4-1PYGt4OpxPisACTHoFqDUwgs-p2ynNvx7mQVv3sC39vaCw5oNC4S3qSHJpO2Td4
    Sh1h28fgeviOlpLQd0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefuddgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    dvhffghfetueeggfdtgeduvedugeekgeeuvddvhfdugeduhfetkeevtdeitdegueenucfk
    phepudeifedruddugedrudefvddrudenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:4-1PYMC_GdH7XO5JlKaWG8QBvYwwNNO04BStAQCj6ikcYi9eTPmdDg>
    <xmx:4-1PYOeQILTWJ-Pz2yDxRued327W3WKU3w7pE2ibGWa_AhVDNaybBQ>
    <xmx:4-1PYLMARReyeJ9G5a-EB6R_M5mECsZDpWcgkmpqO5QIA3Exxt8bCA>
    <xmx:4-1PYB0y7PckFER5EPGmYHoYcpBues0pnniwK9R180g0d5_e_foBTQ>
Received: from localhost (unknown [163.114.132.1])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5938D24005A;
        Mon, 15 Mar 2021 19:29:39 -0400 (EDT)
Date:   Mon, 15 Mar 2021 16:29:36 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 1/5] btrfs: add compat_flags to btrfs_inode_item
Message-ID: <20210315232936.GA3610049@devbig008.ftw2.facebook.com>
References: <cover.1614971203.git.boris@bur.io>
 <f47aa729e2c15b9e3f913c4347bf24562a631772.1614971203.git.boris@bur.io>
 <YE/orPeVtRAON9II@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE/orPeVtRAON9II@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 15, 2021 at 04:07:24PM -0700, Eric Biggers wrote:
> On Fri, Mar 05, 2021 at 11:26:29AM -0800, Boris Burkov wrote:
> > The tree checker currently rejects unrecognized flags when it reads
> > btrfs_inode_item. Practically, this means that adding a new flag makes
> > the change backwards incompatible if the flag is ever set on a file.
> > 
> > Take up one of the 4 reserved u64 fields in the btrfs_inode_item as a
> > new "compat_flags". These flags are zero on inode creation in btrfs and
> > mkfs and are ignored by an older kernel, so it should be safe to use
> > them in this way.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> 
> How does this interact with the RO_COMPAT filesystem flag which is also being
> added?
> 
> - Eric

This allows us to mount at all -- without it, when mounting on an older
system, the logic in fs/btrfs/tree-checker.c would see an unexpected
inode flag value and reject the filesystem entirely.

The RO_COMPAT flag represents the decision to mount RO rather than RW
when a verity file is present (though it suffers from the fact that it
gets set on verity enable, but not unset when the last verity file is
deleted)

I'm now thinking that ro_compat inode flags might be an interesting
option where the tree-checker could indicate we have to mount read only
if it sees an unrecognized value.
