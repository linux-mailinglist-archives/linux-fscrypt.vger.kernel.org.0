Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184D44DCD73
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Mar 2022 19:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbiCQSUm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Mar 2022 14:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbiCQSUh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Mar 2022 14:20:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D980E1480D4;
        Thu, 17 Mar 2022 11:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92DF2B81C19;
        Thu, 17 Mar 2022 18:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46279C340E9;
        Thu, 17 Mar 2022 18:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647541158;
        bh=XirwfFpew8Oi6TTPQ9zLnqLao19saJ+MVbYhFhIY66M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UUUoADrBMFQtkvZjKUyDcc3tYAXYnhjkHHtYrfhY6iS+U3KmyvSRoQ39j0ZO996gH
         +ThqiyvyRzLFnNGpLFR92WbvKCc1g9ztnis7346bdWwCJPxOkjGRACU4jqUpmwhPlv
         rw3sXoOdCj0jWYVrUJXz1UTXlgQ59Nc6XJCR+05TbsHUHjLWsZyAgfCfQnKhKANRg5
         xuFxaA6qQrE+2+SzXGJb8B3h/ETP3tWFeLLXFTXla/ErF6l+s8RRSNJTDSaI5g45gY
         AFoNgZOXZxe9Vs2qfwTg5zch08KxgX5/DEFg5g1o+Z+p5JFRhrTFiIDIc8jGIP3RdB
         2Gj5o4UxDLjvw==
Date:   Thu, 17 Mar 2022 18:19:16 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v8 0/5] tests for btrfs fsverity
Message-ID: <YjN7pDPhPmL95K3O@gmail.com>
References: <cover.1647461985.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1647461985.git.boris@bur.io>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Mar 16, 2022 at 01:25:10PM -0700, Boris Burkov wrote:
> This patchset provides tests for fsverity support in btrfs.
> 
> It includes modifications for generic tests to pass with btrfs as well
> as new tests.
> 

This looks good to me now.  I don't have time to fully review the btrfs-specific
tests (patches 3 and 4), but their premise looks good.

- Eric
