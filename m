Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA8758A74B
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Aug 2022 09:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbiHEHl0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 Aug 2022 03:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240307AbiHEHlH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 Aug 2022 03:41:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53D3FE5;
        Fri,  5 Aug 2022 00:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67C83B82758;
        Fri,  5 Aug 2022 07:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1329DC433D6;
        Fri,  5 Aug 2022 07:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659685260;
        bh=FDrl1bVSs3vw8cqt1QMtI2nK5qak7uBw0zsX+sfXZ6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IdIfb8XF+PJ9ty4iDi9in4KJ7DxjVvCxbi23hjLjT6rz/RP9JMejyYjbFasR+Xvqa
         19QUahV53wSdS1n57/lPla2p+xAA8ae+yLzyi0TMPBiV7agd1KeOvXpIbbQ8Z1v4PE
         5U7MeAEfYPK+ByAKxVBkhU2buGBCEjaxe5BRo6CntcgQB7YhN4mChl34F581gHajOa
         f9TepWrvDTn2UbPER9kYKx1iWMBzNtdtG69T3VxUxZZlD6kR2uJ8Ta16HkmFM0+4j7
         dD5On+GkiU9Hhi/x5IgVqMzi5fvLJjWCyExrie+hVXn+EsjOmI2YRAHNV3bMD8th1H
         zwfQ1OCf70aZw==
Date:   Fri, 5 Aug 2022 00:40:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v5 1/2] fscrypt-crypt-util: add HCTR2 implementation
Message-ID: <YuzJild58hvljFRY@sol.localdomain>
References: <20220803224121.420705-1-nhuck@google.com>
 <20220803224121.420705-2-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803224121.420705-2-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 03, 2022 at 03:41:20PM -0700, Nathan Huckleberry wrote:
> +static void polyval_update(const u8 key[POLYVAL_KEY_SIZE],
> +			   const u8 *msg, size_t msglen,
> +			   u8 accumulator[POLYVAL_BLOCK_SIZE])
> +{
> +	ble128 h;
> +	ble128 aligned_accumulator;
> +	size_t chunk_size;

chunk_size is an unused variable.

Otherwise this looks good:

Reviewed-by: Eric Biggers <ebiggers@google.com>
Tested-by: Eric Biggers <ebiggers@google.com>

- Eric
