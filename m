Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297BB5501E4
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 04:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383848AbiFRCMe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 17 Jun 2022 22:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383838AbiFRCMb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 17 Jun 2022 22:12:31 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4926B7E1;
        Fri, 17 Jun 2022 19:12:30 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-118-63.bstnma.fios.verizon.net [173.48.118.63])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 25I2CDM1005808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 22:12:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1655518335; bh=+nb9PHWG1zNM5loCmspw2/eXHJ8j7lfqISZv3HP0+OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=C8Dt3pPbknLBjjeTeawuQOZmfEM9P99rfnJF3LsxZmoFgBeOuqgRHOtX2rhUKJs7W
         L5CEKRKHMQw30NQMrBpDim2XJr9ek1QyQObsp201fUk8oVte8BgAu2hSgf1cON2bxs
         YlR14a31v2JuYdohpoR4tup2h8wTvLamqj6zdEm5LE+j0opFLrRg1tMLd5Zgngu6EC
         nVIUjeAA6V+zUwhSLQzMLf8TxwURbbGkPmSgCUVHmo+458fY+MmVILfQBqNyAtHA5K
         wxhE0P8gS0lUvFbkbALDqvcr/oMMmYYLSI8/86YLtwAC1Ko9dVBWZdFGSRjCCJVeP5
         8tcorGglvbP9w==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id B387A15C42F3; Fri, 17 Jun 2022 22:12:13 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>, linux-ext4@vger.kernel.org
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Lukas Czerner <lczerner@redhat.com>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v4] ext4: fix up test_dummy_encryption handling for new mount API
Date:   Fri, 17 Jun 2022 22:12:04 -0400
Message-Id: <165551818832.612215.12229175664893969967.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220526040412.173025-1-ebiggers@kernel.org>
References: <20220526040412.173025-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 25 May 2022 21:04:12 -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since ext4 was converted to the new mount API, the test_dummy_encryption
> mount option isn't being handled entirely correctly, because the needed
> fscrypt_set_test_dummy_encryption() helper function combines
> parsing/checking/applying into one function.  That doesn't work well
> with the new mount API, which split these into separate steps.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix up test_dummy_encryption handling for new mount API
      commit: 882e14aa2c302ab8787a2044da9ef1516dc41f7c

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
