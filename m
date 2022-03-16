Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61E34DB74C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Mar 2022 18:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357652AbiCPRiF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Mar 2022 13:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240034AbiCPRiE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Mar 2022 13:38:04 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4984969CC4;
        Wed, 16 Mar 2022 10:36:49 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6CD9B3201F32;
        Wed, 16 Mar 2022 13:36:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 16 Mar 2022 13:36:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=+IcXjFyj+KNzUjiChNEzR+WJm8In33CdG6oyA/
        LYTgM=; b=iGiOMuLbc7YJZxHZOresWNAj0Pc9wwXLfZvAe+NnWYjMdyGs2XZRtt
        ncDkRPiD/CAypitcjfqXIpfuKkvun/prrT6qO6sh4mdrND7A0bxg8tdj5Hqoce5g
        YyXMxduvFYB+m7aOvbpEftPIQQr/ngrzXjtR0UJHvYzBZNWUQMnzGWcBc5c/Bxr3
        peWXpgmyYas/p14a2lkYECRZr9OdNf+djAp5eHyoyjgq+ju1NLXGxF0g80EaQ+Kb
        kSvQI+GJrc0INCTLbIaqYIJNQzMAk+k+YXg2Oz63tXySPH0d3KvhioP4EvzaOl96
        w4cDUinKgunDcZ+SPKUgMXN7g7Ru++nQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+IcXjFyj+KNzUjiCh
        NEzR+WJm8In33CdG6oyA/LYTgM=; b=cmxnLNctLoUS4XKDtNFqNnMG4mekiSIM1
        IEf84khS7a8g4gG/eYLXgBK8IJ2UBUT1mIYURBzbQjIRP4/IBXZ7lgZVwxsmfE9C
        SsKy6jA33JDIX7g3x8/NeOtdVZ+RZMrcyt/WTEw1wyd0ho84mH6mCuCw/LTBQQ5U
        CU3NzEkgc9tVNv4b5NQSHjD6UMj2pB9T3zOphv2xcKJS6u9fK7sARhIfi9Gx3+ng
        oJkSO1uxGbZtI397ubv/90kdJFx2RA+Nl6mCtZ+7aC+thG0vy41Vy/n6LAlBhiq2
        /wujx6pUPDMTxYt+3dRc1Oa+tYN7ZYfEUhQxgelc/k+HGJQfrORQg==
X-ME-Sender: <xms:LSAyYoLob6J7PezTNE8N5WXfM-smP0fsDEt1wK2yBxPxMasEpUVh0g>
    <xme:LSAyYoLnWBBqigfPKVXXKsiEKp05lr7G7pwEI3dY-S2ebRkT8_zEl3LxGbqEBhUDW
    xUOL1hmDnzZ-5DuIOQ>
X-ME-Received: <xmr:LSAyYou2EfWG_BJdqPJSb8N6U7-hcKt4EWwwd_T6r3xIW_1fo7ObyxdhF7OkGQxzBnQVpvNxzHODK14bRK9f1-DIk50sYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefvddguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    ehudevleekieetleevieeuhfduhedtiefgheekfeefgeelvdeuveeggfduueevfeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhsse
    gsuhhrrdhioh
X-ME-Proxy: <xmx:LSAyYlYHk1lo0ayRf6HFimoLn9ANwnlDNXOuUgbfG543QJGzTt3C6w>
    <xmx:LSAyYvYnvc-3AOe5Cq2vKxEKENfWSYP9SDdZKEoEAIwV9yM6_Wyolg>
    <xmx:LSAyYhCkHxHA8zPGdODxost69MonN-wn6wrTzby9HgH7v8KP6FBL-g>
    <xmx:LSAyYrF78mfise0Vkd-ve_WgXFGlyaoO8cKqSW-7VqbfsvX6UdqWGQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Mar 2022 13:36:45 -0400 (EDT)
Date:   Wed, 16 Mar 2022 10:36:44 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v7 2/5] btrfs: test btrfs specific fsverity corruption
Message-ID: <YjIgLFp3XVoch2MY@zen>
References: <cover.1647382272.git.boris@bur.io>
 <a860be32471a885292c2f6f3136cac40bebdbf05.1647382272.git.boris@bur.io>
 <YjId47Ta24xoEbW/@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjId47Ta24xoEbW/@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Mar 16, 2022 at 05:26:59PM +0000, Eric Biggers wrote:
> On Tue, Mar 15, 2022 at 03:15:58PM -0700, Boris Burkov wrote:
> > There are some btrfs specific fsverity scenarios that don't map
> > neatly onto the tests in generic/574 like holes, inline extents,
> > and preallocated extents. Cover those in a btrfs specific test.
> > 
> > This test relies on the btrfs implementation of fsverity in the patch:
> > btrfs: initial fsverity support
> > 
> > and on btrfs-corrupt-block for corruption in the patches titled:
> > btrfs-progs: corrupt generic item data with btrfs-corrupt-block
> > btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  common/btrfs        |   5 ++
> >  common/config       |   1 +
> >  common/verity       |  14 ++++
> >  tests/btrfs/290     | 168 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/290.out |  25 +++++++
> >  5 files changed, 213 insertions(+)
> >  create mode 100755 tests/btrfs/290
> >  create mode 100644 tests/btrfs/290.out
> > 
> > diff --git a/common/btrfs b/common/btrfs
> > index 670d9d1f..c3a7dc6e 100644
> > --- a/common/btrfs
> > +++ b/common/btrfs
> > @@ -511,3 +511,8 @@ _btrfs_metadump()
> >  	$BTRFS_IMAGE_PROG "$device" "$dumpfile"
> >  	[ -n "$DUMP_COMPRESSOR" ] && $DUMP_COMPRESSOR -f "$dumpfile" &> /dev/null
> >  }
> > +
> > +_require_btrfs_corrupt_block()
> > +{
> > +	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs-corrupt-block
> > +}
> > diff --git a/common/config b/common/config
> > index 479e50d1..67bdf912 100644
> > --- a/common/config
> > +++ b/common/config
> > @@ -296,6 +296,7 @@ export BTRFS_UTIL_PROG=$(type -P btrfs)
> >  export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
> >  export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
> >  export BTRFS_TUNE_PROG=$(type -P btrfstune)
> > +export BTRFS_CORRUPT_BLOCK_PROG=$(type -P btrfs-corrupt-block)
> >  export XFS_FSR_PROG=$(type -P xfs_fsr)
> >  export MKFS_NFS_PROG="false"
> >  export MKFS_CIFS_PROG="false"
> > diff --git a/common/verity b/common/verity
> > index 1afe4a82..77766fca 100644
> > --- a/common/verity
> > +++ b/common/verity
> > @@ -3,6 +3,8 @@
> >  #
> >  # Functions for setting up and testing fs-verity
> >  
> > +. common/btrfs
> > +
> >  _require_scratch_verity()
> >  {
> >  	_require_scratch
> > @@ -48,6 +50,15 @@ _require_scratch_verity()
> >  	FSV_BLOCK_SIZE=$(get_page_size)
> >  }
> >  
> > +# Check for userspace tools needed to corrupt verity data or metadata.
> > +_require_fsverity_corruption()
> > +{
> > +	_require_xfs_io_command "fiemap"
> > +	if [ $FSTYP == "btrfs" ]; then
> > +		_require_btrfs_corrupt_block
> > +	fi
> > +}
> 
> This is adding a second definition of _require_fsverity_corruption().
> Probably a rebase error.
> 
> Also, is this hunk in the right patch?  This patch is for adding btrfs/290;
> however, btrfs/290 doesn't use _require_fsverity_corruption() anymore.
> 
> > +
> >  # Check for CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y, as well as the userspace
> >  # commands needed to generate certificates and add them to the kernel.
> >  _require_fsverity_builtin_signatures()
> > @@ -153,6 +164,9 @@ _scratch_mkfs_verity()
> >  	ext4|f2fs)
> >  		_scratch_mkfs -O verity
> >  		;;
> > +	btrfs)
> > +		_scratch_mkfs
> > +		;;
> 
> I think a good way to organize things would be to wire up the existing verity
> tests for btrfs first, then to add the btrfs-specific tests at thet end of the
> series.  That would mean the above hunk would go earlier in the series, not with
> btrfs/290.  It's a little hard to review as-is, as the different hunks needed to
> wire up the existing tests are mixed around in different patches.

I like that. I've definitely been struggling with getting all the hunks
in the right places.. I'll double check it all better before sending it
again. Thanks for the review,

Boris
> 
> - Eric
