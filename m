Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8172133CA22
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Mar 2021 00:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhCOXru (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Mar 2021 19:47:50 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:56765 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230371AbhCOXrT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Mar 2021 19:47:19 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 611F22804;
        Mon, 15 Mar 2021 19:47:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 15 Mar 2021 19:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=vTJZWo6mSsQTSy47CSKsj/6UQ25
        1PPAKY1N/MedJ+A4=; b=rl0a8M8aTo1JrRMk58Vw8NhR+Xm2o8EBDlIdL1bWpc8
        u/QVu2ojAzKd30iIU0009tU/SNOkMGofylZwHwp69OeEl7RCSKERR12GMzZBv4Py
        wCqDco5CroCwBR9v/ii/RxtB/MfR//y668Kir0tsEMpmvD6AysXbzPbWtgNO61wD
        TvfqESLCFmrNu5XH9fugTaG2JG1M0eh0edS4dM1nRWHMUlJa1eAbSxnBbHbLs5fl
        DBvmjWJeVitMEzJ482BBWPCSWcARK6wYxqv+PUglIRniddagVY/dWNJ2n/ukfMTH
        OY4496cTY/mWUtyyMWHIB9Zh2LZgzNUEUMpjZI6k4Jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vTJZWo
        6mSsQTSy47CSKsj/6UQ251PPAKY1N/MedJ+A4=; b=vI/WvRiUoFUCBOqkzKV8sf
        gGrACbnztFJsmWegSDQom2I2JxcgXhruP6rOhJtO6buj6mpNJdEXOa6psYf4l7Iu
        hKIiD+ANV79duXDpSb0D2Vu051Ja6LsbR7OuPqklkj5ECALGtH2lYWQdy/a7Aa+m
        foGTP5Aa2swnWFc9iCEZ68Wk+B8e3msvrtNbGmkt1Brw8i7WvoIpC1uVKnR18anN
        yvwDf4wOyBfoJe8LcSUVRoAemgpC3JdReKT2OMWwSMCaQemvsOtDcEhiS7t7IGjP
        Y6XBbjycbgKoBqlVL4tu0S8Hw1u0NHtoSjV1ql/54ZPbiqfC1H4kLDCa2WWDmxwA
        ==
X-ME-Sender: <xms:BfJPYDm63m_e5f3g8Vh4jj376ECmc0ZTK6asyl1apCPgcK6ZX_8IcQ>
    <xme:BfJPYG2cph9lgvIJnW4RLZnK1p00GBz06s8l_m4XVvw9XA8pTW2MWL7zbF-BqQ5D0
    _1niEuW36PBKi7Nvyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefuddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    dvhffghfetueeggfdtgeduvedugeekgeeuvddvhfdugeduhfetkeevtdeitdegueenucfk
    phepudeifedruddugedrudefvddrudenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:BfJPYJrgVty-d-kUEHEL1Ukgi4V12BIOykxsM_8OM5WpG3f79VUdKQ>
    <xmx:BfJPYLlpo70aeJUmI0TNzMi8rmWLVf8S3EQqCJGGMMd1IbFmltaHwA>
    <xmx:BfJPYB3-X7Dc_u1B-W-swoz91loYRcSieuQk7IOXx6v6Ngw4HLAV7Q>
    <xmx:BvJPYC-Tzjqsg5GBC80nLFlDjZdRJlL0mqZBgYL1_rxHtUslYFzOFQ>
Received: from localhost (unknown [163.114.132.1])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F1A01080057;
        Mon, 15 Mar 2021 19:47:17 -0400 (EDT)
Date:   Mon, 15 Mar 2021 16:47:14 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 0/5] btrfs: support fsverity
Message-ID: <20210315234714.GB3610049@devbig008.ftw2.facebook.com>
References: <cover.1614971203.git.boris@bur.io>
 <YE/pNfSCNdJkXtWN@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE/pNfSCNdJkXtWN@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 15, 2021 at 04:09:41PM -0700, Eric Biggers wrote:
> On Fri, Mar 05, 2021 at 11:26:28AM -0800, Boris Burkov wrote:
> > This patchset provides support for fsverity in btrfs.
> > 
> > At a high level, we store the verity descriptor and Merkle tree data
> > in the file system btree with the file's inode as the objectid, and
> > direct reads/writes to those items to implement the generic fsverity
> > interface required by fs/verity/.
> > 
> > The first patch is a preparatory patch which adds a notion of
> > compat_flags to the btrfs_inode and inode_item in order to allow
> > enabling verity on a file without making the file system unmountable for
> > older kernels. (It runs afoul of the leaf corruption check otherwise)
> > 
> > The second patch is the bulk of the fsverity implementation. It
> > implements the fsverity interface and adds verity checks for the typical
> > file reading case.
> > 
> > The third patch cleans up the corner cases in readpage, covering inline
> > extents, preallocated extents, and holes.
> > 
> > The fourth patch handles direct io of a veritied file by falling back to
> > buffered io.
> > 
> > The fifth patch handles crashes mid-verity enable via orphan items
> > 
> 
> Can you include information about how this was tested?

Right now, I'm testing it with the btrfs xfstest I added as well as a
one-off script that corrupts regular extent data. I'm still working on
integrating the btrfs specifics with the generic verity xfstests, and
how to test verity+compression without hacks.

> 
> Also, fsverity-utils works with btrfs as-is, correct?
> 

As far as I know, yes. I've tested using both the rpm packaged by Fedora
and building from source.

> - Eric
