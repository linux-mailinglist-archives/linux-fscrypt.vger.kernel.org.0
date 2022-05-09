Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D59520996
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 May 2022 01:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiEIXsE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 May 2022 19:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbiEIXqc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 May 2022 19:46:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36745266057;
        Mon,  9 May 2022 16:36:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 414C161301;
        Mon,  9 May 2022 23:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65899C385C3;
        Mon,  9 May 2022 23:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652139369;
        bh=q2Anzy7Vn7+KTWoXEccZSkJLiAE4Av2Zp9ltchMZy8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZqIVr/lAHT4J6IYo+xFJTjXJnf9ROi3nTQkIEu8M2R6xb3HrXFtq/slugDTE52hj5
         R8IB7UOM/OSqknz40bEA1Mo7YnlRMaqmFuPZrF+hgizcHcbiU1VqKOeZuW0GeuIeqW
         2L/Z1khugBcEf3jZrqceyJ1WxJZ1FV9TJf9ssyRDfFO6eLdeISgmH4d55AImOoME08
         AhUuGgpjtKP4SMgmP5ibBMtIDIXp/uvuiuKGTxLUNUuuRTh+C6gbRqulXJ+aQt4sT8
         pUvy5ATNPDxAnbL2iCjlqcgC0VCKqjlmNxL8E1QzJ8EtK0/IxrL97JPtfLJrfH0MBM
         zayNYphe6CUlg==
Date:   Mon, 9 May 2022 16:36:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jeff Layton <jlayton@kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v2 0/7] test_dummy_encryption fixes and cleanups
Message-ID: <YnmlZ15YPS1cy4aV@sol.localdomain>
References: <20220501050857.538984-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501050857.538984-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Apr 30, 2022 at 10:08:50PM -0700, Eric Biggers wrote:
> This series cleans up and fixes the way that ext4 and f2fs handle the
> test_dummy_encryption mount option:
> 
> - Patches 1-2 make test_dummy_encryption consistently require that the
>   'encrypt' feature flag already be enabled and that
>   CONFIG_FS_ENCRYPTION be enabled.  Note, this will cause xfstest
>   ext4/053 to start failing; my xfstests patch "ext4/053: update the
>   test_dummy_encryption tests" will fix that.
> 
> - Patches 3-7 replace the fscrypt_set_test_dummy_encryption() helper
>   function with new functions that work properly with the new mount API,
>   by splitting up the parsing, checking, and applying steps.  These fix
>   bugs that were introduced when ext4 started using the new mount API.
> 
> We can either take all these patches through the fscrypt tree, or we can
> take them in multiple cycles as follows:
> 
>     1. patch 1 via ext4, patch 2 via f2fs, patch 3-4 via fscrypt
>     2. patch 5 via ext4, patch 6 via f2fs
>     3. patch 7 via fscrypt
> 
> Ted and Jaegeuk, let me know what you prefer.
> 
> Changed v1 => v2:
>     - Added patches 2-7
>     - Also reject test_dummy_encryption when !CONFIG_FS_ENCRYPTION
> 
> Eric Biggers (7):
>   ext4: only allow test_dummy_encryption when supported
>   f2fs: reject test_dummy_encryption when !CONFIG_FS_ENCRYPTION
>   fscrypt: factor out fscrypt_policy_to_key_spec()
>   fscrypt: add new helper functions for test_dummy_encryption
>   ext4: fix up test_dummy_encryption handling for new mount API
>   f2fs: use the updated test_dummy_encryption helper functions
>   fscrypt: remove fscrypt_set_test_dummy_encryption()

Since I haven't heard from anyone, I've gone ahead and applied patches 3-4 to
fscrypt#master for 5.19, so that the filesystem-specific patches can be taken in
5.20.  But patches 1-2 could still be applied now.

Any feedback on this series would be greatly appreciated!

- Eric
