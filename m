Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80A94DA4F7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Mar 2022 23:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348289AbiCOWDU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Mar 2022 18:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiCOWDT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Mar 2022 18:03:19 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C795C35C;
        Tue, 15 Mar 2022 15:02:07 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CF01F5C0172;
        Tue, 15 Mar 2022 18:02:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 15 Mar 2022 18:02:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=HXYeKiY8AjlIM21cM6NmnccS0Cc2oqXlPcs9mm
        1Ec+A=; b=JzBkOi1/XFOVPcnGs1MOf5z5a6Ms+nbx3+LdhmipPcTT7XftpZZMWx
        Svqx1YOHguilCyMydw5IZnkBc0uUDYXS4mKrE1mdHnONgpUczhjaKmVidSKX6/GL
        f+GcWglfoDXRC5aOT4zmFj5+ZzgXPE8mWeIpcYEpLEU0B5pXAafaRzquLSGkP0dt
        sFRVvoCfYt4raeMFdK6Hw5nK8bAh9vlBaz/xTGLSNFQJDwMtPktV/vBh8BwI/5ga
        vce+CHJp+RCqf7A0HLNDL14ohdDf5MWGU64rE6/VNxojCzF/D46rAm4KZLleMa+z
        dB3VpC8ITqNFgUvDq0WBh5fQ9kISBT1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=HXYeKiY8AjlIM21cM
        6NmnccS0Cc2oqXlPcs9mm1Ec+A=; b=jyZb3ISkEwgLKN+uHVKhXTL5dWuj0rMZR
        rRC1uSLqcgZUC2asGAwp/eOiZklie+5sx244W1IXpCg9oPnTiV6JxKn6VZA0U1rY
        kTLIaoKb2rJO0yo5IoUj794oXJcut5Va16In828gIm50Bf/y+451J0BBUlS5o7Ax
        +bZNvvpyHj5ftFGdusQtlljUSXpGghcSBecxB+/r2G3WWJcMwknbYRUDSzFCZv2+
        htxrPpf4vjmZaWGSnltdrlYLgUhURlazVJIB81xuTj0bmRJufmeAAeV1LHF+u/J+
        8gsEzg3HL+fNYOWq3UlkhXRfH6ROVTbgklDnJw+ZkmHy4Qeq8D6Tg==
X-ME-Sender: <xms:3AwxYkS3gLgNNranUUx-F5QfheidtUJAvqtIovTx5uC0NzW0XNRAag>
    <xme:3AwxYhw8G2YoPEUz_bkihLlEv2rHMvN7FZYzyRiVwkbIibQWKEYitscvLMr7ocD97
    nCyGobc7DYdAAh0LIs>
X-ME-Received: <xmr:3AwxYh0Yypr7wzTQGo5LqRLvrHHSSo1HA_UGClL_d7v5wB1R-1m94pUPK8rV6Z34r7BFpBVAqx6uloy0XRPqS9yXFKZMZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeftddgudehhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    ehudevleekieetleevieeuhfduhedtiefgheekfeefgeelvdeuveeggfduueevfeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhsse
    gsuhhrrdhioh
X-ME-Proxy: <xmx:3AwxYoC-VR95lSfejQWut4CbqpqLdu1_EEc5fF4tM6-ZqZx5J0GMeA>
    <xmx:3AwxYtjg7DoIpG-jt7DtxBHiGdXiuJNhTK_t6W8LaxSJFGGsZF8RhQ>
    <xmx:3AwxYkpo5ADx5inKrXq3GJ9OdZHHZEDmIe3s86FrPG1imwanU5C5Vg>
    <xmx:3AwxYivNkeivJhJ10sIFZAAli0Di8d4G2qQoDGenvZIummIFrOmpvA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Mar 2022 18:02:04 -0400 (EDT)
Date:   Tue, 15 Mar 2022 15:02:02 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v6 1/4] btrfs: test btrfs specific fsverity corruption
Message-ID: <YjEM2k/UFOLar3ix@zen>
References: <cover.1644883592.git.boris@bur.io>
 <de58122e6cb1712fa5304f0759b40b36351dfc36.1644883592.git.boris@bur.io>
 <Yi/Wq/e7qv0jcQIb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yi/Wq/e7qv0jcQIb@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 14, 2022 at 11:58:35PM +0000, Eric Biggers wrote:
> On Mon, Feb 14, 2022 at 04:09:55PM -0800, Boris Burkov wrote:
> > diff --git a/common/verity b/common/verity
> > index 38eea157..eec8ae72 100644
> > --- a/common/verity
> > +++ b/common/verity
> > @@ -3,6 +3,8 @@
> >  #
> >  # Functions for setting up and testing fs-verity
> >  
> > +. common/btrfs
> 
> Why does common/btrfs need to be included here?

To get _require_btrfs_corrupt_block. I can move that in here, as it
doesn't have any non-verity use case in btrfs tests yet. But it should
probably stay a named function rather than get rolled into
require_fsverity_corruption if I make btrfs/290 use it directly (which I
think is a good suggestion).

> 
> > +# Check for userspace tools needed to corrupt verity data or metadata.
> > +_require_fsverity_corruption()
> > +{
> > +	_require_xfs_io_command "fiemap"
> > +	if [ $FSTYP == "btrfs" ]; then
> > +		_require_btrfs_corrupt_block
> > +	fi
> > +}
> 
> Which function(s), specifically, is this function a prerequisite for?  Based on
> the name, it sounds like it would be a prerequisite for calling
> _fsv_scratch_corrupt_bytes() and _fsv_scratch_corrupt_merkle_tree().  But that's
> apparently not the case, seeing as generic/576 calls
> _fsv_scratch_corrupt_bytes() but doesn't call _require_fsverity_corruption(),
> and your new test btrfs/290 calls _require_fsverity_corruption() but doesn't
> call either _fsv_scratch_corrupt_bytes() or _fsv_scratch_corrupt_merkle_tree().
> 
> So, the purpose of this function is unclear.
> 
> Perhaps it should be a prerequisite for all _fsv_scratch_corrupt*() functions,
> and btrfs/290 should check for btrfs-corrupt-block directly?

My intent was for it to be a requirement for _fsv_scratch_corrupt_bytes
and _fsv_scratch_corrupt_merkle_tree, but I missed 576, since I was
testing with btrfs and that doesn't have transparent encryption. Apologies
for missing that test. I'll make _require_fsverity_corruption 1:1 with
_fsv_scratch_corrupt_bytes. However, I believe I still need
btrfs_corrupt_block here, since that is part of the "generic" corruption
for btrfs.

> 
> - Eric
