Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CD357DC5D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Jul 2022 10:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbiGVI3C (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 22 Jul 2022 04:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbiGVI3B (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 22 Jul 2022 04:29:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665439E793;
        Fri, 22 Jul 2022 01:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0600661D1D;
        Fri, 22 Jul 2022 08:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F872C341C6;
        Fri, 22 Jul 2022 08:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658478539;
        bh=a5jDdfGqOSYPOdBr/dRhHaxh3Xr4VJFqzGplwBVNszI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZMIwH2dfJ74LE6FO6bZLmX7j5WndYM5Q8XiZmjDLaAjIvCCLPS6r4q444/Xax2MMz
         Cc7GEaoAo4Pxnf/2dClhCMluHOHg9FkciSAfEcUKpVUkunyW8+fShntD0wzJq6U3FC
         sRgcs+0hUs1zG4Ix38UNJxij9vlPPwHuSEnYaerFu4WZ+/7MJ/9GKrtUmQ4T6ILmMh
         MuoBbnB6QPMjrCZiFtuhqNjkglX/Np2RQSmvcLGEYvnG5zHfxZ1jlRIVrOZoURHYmL
         7t/rF67396rZj9aGTI2B1wOTCKShRknHvWFbO/9FVJ0VMrDYINVe7jcx3m7g0bAYZH
         qMBDsJvPRQgpg==
Date:   Fri, 22 Jul 2022 01:28:57 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: RFC: what to do about fscrypt vs block device interaction
Message-ID: <YtpfyZ8Dr9duVr45@sol.localdomain>
References: <20220721125929.1866403-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721125929.1866403-1-hch@lst.de>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 21, 2022 at 02:59:29PM +0200, Christoph Hellwig wrote:
> Hi Eric,
> 
> fscrypt is the last major user of request_queues in file system code.
> A lot of this would be easy to fix, and I have some pending patches,
> but the major roadblocker is that the fscrypt_blk_crypto_key tries
> to hold it's own refefrences to the request_queue.  The reason for
> that is documented in the code, as in that the master key can outlive
> the super_block.  But can you explain why we need to do that?  I
> think evicting the key on unmount would be very much the expected
> behavior.  With that we could rework how fscrypt interacts with the
> file systems for inline encryption and avoid the nasty returning
> of the devics in the get_devices method.  See my draft patch below,
> for which I'm stuck at how to find a super_block for the evict side,
> which seems to require larger logic changes.

Yes, evicting the blk-crypto keys at unmount is the expected behavior.  And it
basically is the actual behavior as well, but as currently implemented there can
be a slight delay.  There are two reasons for the delay, both probably solvable.

The first is that ->s_master_keys isn't released until __put_super().  It
probably should be moved earlier, maybe to generic_shutdown_super().

The second reason is that the keyrings subsystem is being used to keep track of
the superblock's master keys (for several reasons, such as integrating with the
key quotas), and a side effect of that we get the delay of the keyring's
subsystem garbage collector before the destroy callbacks of the keys actually
run.  That delays the eviction of the blk-crypto keys.

To avoid that, I think we could go through and evict all the blk_crypto_keys
(i.e. call fscrypt_destroy_prepared_key() on the fscrypt_prepared_keys embedded
in each fscrypt_master_key) during the unmount itself, separating it from the
destruction of the key objects from the keyring subsystem's perspective.
That could happen in the moved call to fscrypt_sb_free().

I don't remember any specific reason why this wasn't done originally.
blk-crypto support was added later on, so when it was added I think we just
defaulted to keeping the same lifecycle for everything as before.

- Eric
