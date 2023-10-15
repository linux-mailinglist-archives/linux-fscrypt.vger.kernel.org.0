Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5C57C9831
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 Oct 2023 08:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjJOGgI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 Oct 2023 02:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJOGgI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 Oct 2023 02:36:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECC0C5;
        Sat, 14 Oct 2023 23:36:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E995BC433C8;
        Sun, 15 Oct 2023 06:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697351766;
        bh=Sd1QgDLbyxpjW3rB0voNOUVDXTlujkqiUyHJ+pw4XhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mpIja0WctzkAVcALOmIHYAaHl9BQapOHwhEXVRB6cXQtA1WRc/X2yLsXfOVrbtrzh
         L4J834SpABf1sRnFBMS4jwHtUFlD7KpLztX2AKf2gIgkl5Pezvg/BY9TH73X70tV2s
         695XvxRuaeB0ZsirsLGRIfPMax65yzk8nxS4q41ikckpcfDTXdns5e4pKWaGu4/O8R
         TF9xaT/yWy81ZLmDx1Id3uZ7xA9ZUf7mcGh7X41rKmnvkHOEYbkFEn2isOZ6h4jK8Y
         1vXIp80Q6xLXfoKdAO/OPzkG3cEzKbKnzUbe+mSOqZOiEDHk+7PpJxDTQ5V+ZKyTtI
         IGil+Pmu1ao/w==
Date:   Sat, 14 Oct 2023 23:36:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 03/36] fscrypt: add per-extent encryption support
Message-ID: <20231015063604.GE10525@sol.localdomain>
References: <cover.1696970227.git.josef@toxicpanda.com>
 <f2096b710ebad976d9bb5f3176e6c6fa8bab19dc.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2096b710ebad976d9bb5f3176e6c6fa8bab19dc.1696970227.git.josef@toxicpanda.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 10, 2023 at 04:40:18PM -0400, Josef Bacik wrote:
> This adds the code necessary for per-extent encryption.  We will store a
> nonce for every extent we create, and then use the inode's policy and
> the extents nonce to derive a per-extent key.
> 
> This is meant to be flexible, if we choose to expand the on-disk extent
> information in the future we have a version number we can use to change
> what exists on disk.
> 
> The file system indicates it wants to use per-extent encryption by
> setting s_cop->set_extent_context.  This also requires the use of inline
> block encryption.
> 
> The support is relatively straightforward, the only "extra" bit is we're
> deriving a per-extent key to use for the encryption, the inode still
> controls the policy and access to the master key.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Planning to take a closer look at this patch, but one quick comment: could you
explicitly document the choice to rely on blk-crypto?  There are reasons for
doing that, and it would be helpful to document them.

- Eric
