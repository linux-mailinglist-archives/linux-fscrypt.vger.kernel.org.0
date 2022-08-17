Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F8859664C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 02:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbiHQA3D (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 16 Aug 2022 20:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237647AbiHQA27 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 16 Aug 2022 20:28:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F90986706;
        Tue, 16 Aug 2022 17:28:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73805B81B73;
        Wed, 17 Aug 2022 00:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA79C433D6;
        Wed, 17 Aug 2022 00:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660696133;
        bh=Rzz/M8Q0tiosyOZooUlRGvQSVZx536FrRe7zGsi+7Dw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDp3WaZXGKqZH0pV5Z0TDzxsQtrGn65ZZXCECzYW9UwwnAs7mmtdEbJSUDJJJyx9R
         yyZmjsgCkJs61FOGksO1agxe+1a9xtLouGvWG1jjSzv+MtyC9AeA3F0F7RG/NGFH1x
         4t63u6v4IUzyAvNjQ4aqDN5Df2jHeQWK9mrCw4uaupqzjGu+aicLoN5MBb3c/csfOm
         41/IaGQdhmnc69iKD2xj4AIFt8q+Btc65x5tToMCg9ou1f7R8jPG8SCFAlc1Rcy9vy
         hv22HRnIjxYuL9sXZML7i8ty/6H+jMfuHBg4NKkyGFF6kuIXHWzKjf9hxh4HYuhyZN
         EIAxyxL1ddFDg==
Date:   Tue, 16 Aug 2022 17:28:52 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: RFC: what to do about fscrypt vs block device interaction
Message-ID: <Yvw2REXUEgvQQTWg@sol.localdomain>
References: <20220721125929.1866403-1-hch@lst.de>
 <YtpfyZ8Dr9duVr45@sol.localdomain>
 <20220722160349.GA10142@lst.de>
 <Ytrrbd0F6OBdMcTv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytrrbd0F6OBdMcTv@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 22, 2022 at 06:24:45PM +0000, Eric Biggers wrote:
> On Fri, Jul 22, 2022 at 06:03:49PM +0200, Christoph Hellwig wrote:
> > > To avoid that, I think we could go through and evict all the
> > > blk_crypto_keys (i.e. call fscrypt_destroy_prepared_key() on the
> > > fscrypt_prepared_keys embedded in each fscrypt_master_key) during the
> > > unmount itself, separating it from the destruction of the key objects
> > > from the keyring subsystem's perspective. That could happen in the
> > > moved call to fscrypt_sb_free().
> 
> Note: for iterating through the keys in ->s_master_keys, I'd try something like
> assoc_array_iterate(&sb->s_master_keys->keys, fscrypt_teardown_key, sb)
> 
> > 
> > I'll give this a try.
> > 
> > What would be a good test suite or set of tests to make sure I don't
> > break fscrypt operation?
> 
> You can run xfstests on ext4 and f2fs with "-g encrypt", both with and without
> the inlinecrypt mount option.
> https://www.kernel.org/doc/html/latest/filesystems/fscrypt.html#tests shows the
> commands to do this with kvm-xfstests, but it can also be done with regular
> xfstests.  Note that for the inlinecrypt mount option to work you'll need a
> kernel with CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y and
> CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y.
> 
> There are relevant things that aren't tested by this, such as f2fs's
> multi-device support and whether the blk-crypto keys really get evicted, but
> that's the best we have.

FYI, I'm working on a patchset that will address the issue with
blk_crypto_evict_key() that you were having trouble with here.  It turns out
there are some actual bugs caused by how fscrypt does things with
->s_master_keys, so I'm planning a larger cleanup that changes ->s_master_keys
to be a regular hash table instead, with lifetime rules adjusted accordingly.

- Eric
