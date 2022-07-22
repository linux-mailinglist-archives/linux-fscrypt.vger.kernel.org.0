Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEA957E675
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Jul 2022 20:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbiGVSYt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 22 Jul 2022 14:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236186AbiGVSYs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 22 Jul 2022 14:24:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722F49D521;
        Fri, 22 Jul 2022 11:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18991622BC;
        Fri, 22 Jul 2022 18:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C06C341C7;
        Fri, 22 Jul 2022 18:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658514286;
        bh=H++UBAm7qCLlAd4t1+IJbEAKbOeyI9vnXF4BEsuYggM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BUrKRtY6PqkT36XXPLeTizxdv+GQ8qXo8UwkdYi0GrmEQzwL16E52ZpRuaoSvO6Oz
         A0PjnZ+1RmTPPbfq8y7a/jSsScdddCCZ8w04/44qyk8IdxdTp8de7r2ArfCIQFk1pS
         3SY9p/o3bGfSgXKVe7SOosDh06xenRrjLvzvD6DbuA5SafiTWbG7TWklJ0CjXXVG4j
         FWRa37DLsPKsznOt98ccWzPHWbbwJsWOUkDOcoUNxoir0Ry3VJXxBZe3yMrURsqOjG
         EgD3ie8RmmXgOuG5nGrCCC4OWDdavAWcXTNKLd9N9hyOn6b+t4CXBOYctAAK2tsT0V
         MrnnKeJ9aSwTA==
Date:   Fri, 22 Jul 2022 18:24:45 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: RFC: what to do about fscrypt vs block device interaction
Message-ID: <Ytrrbd0F6OBdMcTv@gmail.com>
References: <20220721125929.1866403-1-hch@lst.de>
 <YtpfyZ8Dr9duVr45@sol.localdomain>
 <20220722160349.GA10142@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722160349.GA10142@lst.de>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 22, 2022 at 06:03:49PM +0200, Christoph Hellwig wrote:
> > To avoid that, I think we could go through and evict all the
> > blk_crypto_keys (i.e. call fscrypt_destroy_prepared_key() on the
> > fscrypt_prepared_keys embedded in each fscrypt_master_key) during the
> > unmount itself, separating it from the destruction of the key objects
> > from the keyring subsystem's perspective. That could happen in the
> > moved call to fscrypt_sb_free().

Note: for iterating through the keys in ->s_master_keys, I'd try something like
assoc_array_iterate(&sb->s_master_keys->keys, fscrypt_teardown_key, sb)

> 
> I'll give this a try.
> 
> What would be a good test suite or set of tests to make sure I don't
> break fscrypt operation?

You can run xfstests on ext4 and f2fs with "-g encrypt", both with and without
the inlinecrypt mount option.
https://www.kernel.org/doc/html/latest/filesystems/fscrypt.html#tests shows the
commands to do this with kvm-xfstests, but it can also be done with regular
xfstests.  Note that for the inlinecrypt mount option to work you'll need a
kernel with CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y and
CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y.

There are relevant things that aren't tested by this, such as f2fs's
multi-device support and whether the blk-crypto keys really get evicted, but
that's the best we have.

- Eric
