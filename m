Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CB54AB194
	for <lists+linux-fscrypt@lfdr.de>; Sun,  6 Feb 2022 20:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbiBFTGR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 6 Feb 2022 14:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiBFTGQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 6 Feb 2022 14:06:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D234C06173B
        for <linux-fscrypt@vger.kernel.org>; Sun,  6 Feb 2022 11:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DEB261223
        for <linux-fscrypt@vger.kernel.org>; Sun,  6 Feb 2022 19:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98A6C340E9
        for <linux-fscrypt@vger.kernel.org>; Sun,  6 Feb 2022 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644174368;
        bh=04HzP7f7x2TomVgc+PGm+6pgtANXdHpvYSVKGFTEKYI=;
        h=Date:From:To:Subject:From;
        b=Fn6oC0i7wpafOhyO1FVDAN1GKqR4M/1ecPBGWfzdmTM0M7ZX9Ud7LlD0SrK5y4fyo
         uHe6g0JFmMHnaM/UOAjn/n+2X/6s/qSTa/BtBaGb4J8aXu1sgRCsW13zPxCRPo3EYm
         fgSIUs7xqYaY/eZvFBb1omzpDXXcTu5gK6o6KxsHDtLdNl/qtkdt31482pzzQiRQ9b
         Yl4nqOhTzPOxa+TIQ4H6+YheClA5qkxKRhWwc6w0E/v45DDfRkZitrDUUCJY3qD4G+
         DgN9P0qnjJ/JVhNtrPkKRuy5L2w4SuqGHABoA+Zt1zOAlQHcvhmp0aIHzsGR2+i9pn
         uYKhgQ3lMbIWg==
Date:   Sun, 6 Feb 2022 11:06:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [ANNOUNCE] fsverity-utils v1.5
Message-ID: <YgAcHxdkQ5qwFiLy@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

I've released fsverity-utils v1.5:

Git: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/tag/?h=v1.5
Tarball: https://kernel.org/pub/linux/kernel/people/ebiggers/fsverity-utils/v1.5/

Release notes (these can also be found in the NEWS.md file):

* Made the `fsverity sign` command and the `libfsverity_sign_digest()` function
  support PKCS#11 tokens.

* Avoided a compiler error when building with musl libc.

* Avoided compiler warnings when building with OpenSSL 3.0.

* Improved documentation and test scripts.

- Eric
