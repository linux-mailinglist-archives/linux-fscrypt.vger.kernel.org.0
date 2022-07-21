Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C109057CAF0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Jul 2022 14:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiGUMzE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Jul 2022 08:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiGUMzE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Jul 2022 08:55:04 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1C640BE7;
        Thu, 21 Jul 2022 05:55:03 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C80A168AFE; Thu, 21 Jul 2022 14:54:59 +0200 (CEST)
Date:   Thu, 21 Jul 2022 14:54:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Israel Rukshin <israelr@nvidia.com>,
        Linux-block <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Nitzan Carmi <nitzanc@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/1] block: Add support for setting inline encryption
 key per block device
Message-ID: <20220721125459.GC20555@lst.de>
References: <1658316391-13472-1-git-send-email-israelr@nvidia.com> <1658316391-13472-2-git-send-email-israelr@nvidia.com> <Ytj249InQTKdFshA@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytj249InQTKdFshA@sol.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 20, 2022 at 11:49:07PM -0700, Eric Biggers wrote:
> On the other hand, I'd personally be fine with saying that this isn't actually
> needed, i.e. that allowing arbitrary overriding of the default key is fine,
> since userspace should just set up the keys properly.  For example, Android
> doesn't need this at all, as it sets up all its keys properly.  But I want to
> make sure that everyone is generally okay with this now, as I personally don't
> see a fundamental difference between this and what the dm-crypt developers had
> rejected *very* forcefully before.  Perhaps it's acceptable now simply because
> it wouldn't be part of dm-crypt; it's a new thing, so it can have new semantics.

I agree with both the dm-crypt maintainer and you on this.  dm-crypt is
a full disk encryption solution and has to provide guarantees, so it
can't let upper layers degrade the cypher.  The block layer support on
the other hand is just a building block an can as long as it is carefully
documented.

> I'm wondering if anyone any thoughts about how to allow data_unit_size >
> logical_block_size with this patch's approach.  I suppose that the ioctl could
> just allow setting it, and the block layer could fail any I/O that isn't
> properly aligned to the data_unit_size.

We could do that, but we'd need to comunicate the limit to the upper
layers both in the kernel an user space.  Effectively this changes the
logical block size for all practical purposes.
