Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8166EA72EF
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Sep 2019 20:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfICS6d (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 3 Sep 2019 14:58:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfICS6d (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 3 Sep 2019 14:58:33 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D34562A09B3;
        Tue,  3 Sep 2019 18:58:32 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEE6B1001B02;
        Tue,  3 Sep 2019 18:58:28 +0000 (UTC)
Date:   Tue, 3 Sep 2019 14:58:28 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v13 6/6] md: dm-crypt: omit parsing of the encapsulated
 cipher
Message-ID: <20190903185827.GD13472@redhat.com>
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
 <20190819141738.1231-7-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819141738.1231-7-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 03 Sep 2019 18:58:33 +0000 (UTC)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 19 2019 at 10:17am -0400,
Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Only the ESSIV IV generation mode used to use cc->cipher so it could
> instantiate the bare cipher used to encrypt the IV. However, this is
> now taken care of by the ESSIV template, and so no users of cc->cipher
> remain. So remove it altogether.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Mike Snitzer <snitzer@redhat.com>

Might be wise to bump the dm-crypt target's version number (from
{1, 19, 0} to {1, 20, 0}) at the end of this patch too though...

But again, Herbert please feel free to pull this into your 5.4 branch.

Thanks,
Mike
