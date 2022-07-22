Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298A657E409
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Jul 2022 18:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiGVQDy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 22 Jul 2022 12:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiGVQDx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 22 Jul 2022 12:03:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269BD5A14D;
        Fri, 22 Jul 2022 09:03:53 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0086668AFE; Fri, 22 Jul 2022 18:03:49 +0200 (CEST)
Date:   Fri, 22 Jul 2022 18:03:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-fscrypt@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: RFC: what to do about fscrypt vs block device interaction
Message-ID: <20220722160349.GA10142@lst.de>
References: <20220721125929.1866403-1-hch@lst.de> <YtpfyZ8Dr9duVr45@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtpfyZ8Dr9duVr45@sol.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 22, 2022 at 01:28:57AM -0700, Eric Biggers wrote:
> Yes, evicting the blk-crypto keys at unmount is the expected behavior.
> And it basically is the actual behavior as well, but as currently
> implemented there can be a slight delay.  There are two reasons for the
> delay, both probably solvable.
> 
> The first is that ->s_master_keys isn't released until __put_super().
> It probably should be moved earlier, maybe to generic_shutdown_super().

Yes, this does sound like a good idea.

> The second reason is that the keyrings subsystem is being used to keep
> track of the superblock's master keys (for several reasons, such as
> integrating with the key quotas), and a side effect of that we get the
> delay of the keyring's subsystem garbage collector before the destroy
> callbacks of the keys actually  run.  That delays the eviction of the
> blk-crypto keys.
> 
> To avoid that, I think we could go through and evict all the
> blk_crypto_keys (i.e. call fscrypt_destroy_prepared_key() on the
> fscrypt_prepared_keys embedded in each fscrypt_master_key) during the
> unmount itself, separating it from the destruction of the key objects
> from the keyring subsystem's perspective. That could happen in the
> moved call to fscrypt_sb_free().

I'll give this a try.

What would be a good test suite or set of tests to make sure I don't
break fscrypt operation?
