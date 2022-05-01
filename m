Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137095168DC
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 May 2022 01:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352623AbiEAX32 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 19:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiEAX31 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 19:29:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB89CB877;
        Sun,  1 May 2022 16:25:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9ECBB80B55;
        Sun,  1 May 2022 23:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A4FC385AA;
        Sun,  1 May 2022 23:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651447557;
        bh=IzlkBaID+yqzckMbyFJ/v3HtDSN7Zh502N2RUOzye0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XnO4e7DKqT2ZsM8Af133H5G4PxU9pkA7aWwvu16c9exjCWd2iCiSoy3igHOgWv58T
         KXR1C1PqyYw/dSEmFsgnXo0XkqAIaSyKnR29DwxV8RlfihnV2i/OZBX1FWHgSYTe02
         1e6YIiwgyrkR7uBdzmCaRjfpmq8bUEWQo2tq9d3eRtGdoSAYo09zZUMWoz0hNk5dyi
         O658IYNQHbys+E13tXmPl2256gwrLOhdbU9fcKAkBauraxa4Xrapsqv+GOkujM8/Ff
         i8mPrKdyBzHzsKDE7RXAbqE12b7yB/TfhVSbWCQQiPMDCPuYBxg+Nz8D5YGvl9Zrpd
         l2vdwWRc3UVIQ==
Date:   Sun, 1 May 2022 16:25:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v9 5/5] generic: test fs-verity EFBIG scenarios
Message-ID: <Ym8XATu0MLOWGefF@sol.localdomain>
References: <cover.1651012461.git.boris@bur.io>
 <b79c0fe9c23a5911943f797dedb25f28f1759f73.1651012461.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b79c0fe9c23a5911943f797dedb25f28f1759f73.1651012461.git.boris@bur.io>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Apr 26, 2022 at 03:40:16PM -0700, Boris Burkov wrote:
> btrfs, ext4, and f2fs cache the Merkle tree past EOF, which restricts
> the maximum file size beneath the normal maximum. Test the logic in
> those filesystems against files with sizes near the maximum.
> 
> To work properly, this does require some understanding of the practical
> but not standardized layout of the Merkle tree. This is a bit unpleasant
> and could make the test incorrect in the future, if the implementation
> changes. On the other hand, it feels quite useful to test this tricky
> edge case. It could perhaps be made more generic by adding some ioctls
> to let the file system communicate the maximum file size for a verity
> file or some information about the storage of the Merkle tree.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  common/verity         | 11 ++++++++
>  tests/generic/690     | 64 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/690.out |  7 +++++
>  3 files changed, 82 insertions(+)
>  create mode 100755 tests/generic/690
>  create mode 100644 tests/generic/690.out

Unchanged from v8 which I had given R-b for:

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
