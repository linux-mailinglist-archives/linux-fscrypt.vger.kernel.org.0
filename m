Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C9F67B90D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jan 2023 19:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235552AbjAYSMh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Jan 2023 13:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbjAYSMg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Jan 2023 13:12:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBB346090;
        Wed, 25 Jan 2023 10:12:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22855B81B6B;
        Wed, 25 Jan 2023 18:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C292C433EF;
        Wed, 25 Jan 2023 18:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674670352;
        bh=F0+KwPG8MCwYAmQMNO2Dkfq1GxfcBnu7RqgtyJ5Rt1s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qdnzSCN8CDjbnB796I3wpMFxkId5shNmhXbKyYOTDqY86+dTy/nu/EMGDMVL9D1TW
         8bPogFWHZK4MDvcy4NWmESfgiL7cXbpG6hpKGGxgyRCPbZ12KU5tyllY/lpkwY9mKH
         0oQTr76F0wuO7KuePnGDRALqu3RTN780VmT2c5EyWYr+uF86UKNdbqzJzZbOrOGcfY
         kvxsViMdoDDOV1NVXgxjQ7bv8DkPiGdUzC+nLkLdxZBd+5Fzds7YQNadrOCXTcHKMH
         VJHCi+Nyjgn8xNfOPFNLpNQ0xaVLiH/h5y0WOfk1YHU/YB624gXfRDY7u0XITSCDco
         YLgP4Qn9zaRaw==
Date:   Wed, 25 Jan 2023 10:12:30 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/4] fsverity: pass pos and size to
 ->write_merkle_tree_block
Message-ID: <Y9FxDqhdLe5RJ9Iq@sol.localdomain>
References: <20221214224304.145712-1-ebiggers@kernel.org>
 <20221214224304.145712-5-ebiggers@kernel.org>
 <20230125122227.lgwp2t5tdzten3dk@aalbersh.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125122227.lgwp2t5tdzten3dk@aalbersh.remote.csb>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[Added back Cc's.  Please use Reply-All instead of Reply!]

On Wed, Jan 25, 2023 at 01:22:27PM +0100, Andrey Albershteyn wrote:
> On Wed, Dec 14, 2022 at 02:43:04PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > fsverity_operations::write_merkle_tree_block is passed the index of the
> > block to write and the log base 2 of the block size.  However, all
> > implementations of it use these parameters only to calculate the
> > position and the size of the block, in bytes.
> > 
> > Therefore, make ->write_merkle_tree_block take 'pos' and 'size'
> > parameters instead of 'index' and 'log_blocksize'.
> 
> Hi Eric,
> 
> Thanks for the quick responses with changes to fs-verity!
> 
> With this patch shouldn't the read_merkle_tree_block() also change
> to [pos, size] args? I see that ext4 uses index to read the page at
> that index + file size. But I suppose that when Merkle tree block
> size will vary (e.g. 8k) it will require position + size.

Not yet.  It's actually read_merkle_tree_page(), not read_merkle_tree_block().
The callees want a page index, and pages always have size PAGE_SIZE.  So the
current function prototype is appropriate for the current design.

> In XFS as we store the page under the xattr with "pos" as a name
> we also need a "pos" while reading the page. So, currently XFS can
> use index << log2(PAGE_SHIFT) or will need to get also log_blocksize
> from descriptor.

But you definitely need to think about what changes should be made to allow XFS
to do the Merkle tree caching the way the other XFS developers want it to do.
There will be significantly more to that than potentially changing a function
prototype.  There's been some discussion of this on the "fs-verity support for
XFS" thread, but there's not a detailed proposal yet.

Note: you should store Merkle tree blocks in the xattrs instead of "pages", so
that the on-disk format isn't tied to the page size.

- Eric
