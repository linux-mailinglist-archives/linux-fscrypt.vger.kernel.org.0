Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99094AD4C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Jun 2019 23:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbfFRV2H (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Jun 2019 17:28:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39088 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729196AbfFRV2G (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Jun 2019 17:28:06 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so1042120wrt.6
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Jun 2019 14:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=NgQVif3SJzNXiAZCno1M2C2zTfT84Y/U1CUnXY4DVsM=;
        b=zoKcuhnPc6YVnlS3X3fUJX74xIyUsF/Wc3w19VeACAsSP3fFi6sXxOrYahrn4KHoWb
         M4wXn/yuqgZOr4/oxr98AUkEp3V/OlQnzQxj/5NCSiPikL2n62i6k0JH1clAtRtEdhWh
         D2B3Yb/hvBB3wnXKMPBfraXnKPX1XSOdGLz/Vyl3ApnwHXU4nzTqNnzL98gOCJPuuASf
         brEC8unTqTLjtqnIxDWeuOXc+NZRrrKybJRa7I9oTfyQyJ5JhGzpgl3LDyB8d+L8GKo7
         TScSIfSdX1U/dOcgU6Rsny5veX3bsVYUtWP73SPGPTXURai1Pi0D3mhbBlCl7xib8QDd
         j/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NgQVif3SJzNXiAZCno1M2C2zTfT84Y/U1CUnXY4DVsM=;
        b=b7sP+aJkjh9OuVEuUqF4GVBg51iXTT5kmHIwFk2LsMuIX/chTYRErsjPPYn2iOZUlg
         IyUQOskZzOyRuizdGXDgYVZvLq9f8LJ8iJ8c+MN2QXx/dKONipy+/DEXC25xzagndqo2
         xH3t2MDevUw7DCJn3+hBTGiYqZU5hBjQHwrQq68+GdGRD9enCPkLMsYb2JqLN/4Umil0
         w7CakbZtMXKoNRPrjXHeAgIvjgVXmExSyLW1GT+42odbaukFvw3AElkJGRuB0iCl/n7V
         zQCpIZ7tEEwoYTFxJqQnRjM+MPOdYRDwMKl5g8b6HML6AZJ8w4IYYxHQWilj1msc/qW5
         /TLQ==
X-Gm-Message-State: APjAAAUeWFj4q8sDbF9alVFVzaWoHgZQKprjybhmYOXGx5cq2HmAmqcL
        GFvisd5H71MIprngLG4OajISBA==
X-Google-Smtp-Source: APXvYqxCmwvTG3xENPWFv7zECq2kphLnb2KN6MXafy6Nrte3k30uDJ2JFjEDHUMHHdlkW7sQi76feA==
X-Received: by 2002:adf:f442:: with SMTP id f2mr16345724wrp.275.1560893284262;
        Tue, 18 Jun 2019 14:28:04 -0700 (PDT)
Received: from e111045-lin.arm.com (lfbn-nic-1-216-10.w2-15.abo.wanadoo.fr. [2.15.62.10])
        by smtp.gmail.com with ESMTPSA id h21sm2273831wmb.47.2019.06.18.14.28.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 14:28:03 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2 0/4]  crypto: switch to crypto API for ESSIV generation
Date:   Tue, 18 Jun 2019 23:27:45 +0200
Message-Id: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series creates an ESSIV template that produces a skcipher or AEAD
transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
(or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
encapsulated sync or async skcipher/aead by passing through all operations,
while using the cipher/shash pair to transform the input IV into an ESSIV
output IV.

This matches what both users of ESSIV in the kernel do, and so it is proposed
as a replacement for those, in patches #2 and #4.

This code has been tested using the fscrypt test suggested by Eric
(generic/549), as well as the mode-test script suggested by Milan for
the dm-crypt case. I also tested the aead case in a virtual machine,
but it definitely needs some wider testing from the dm-crypt experts.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@google.com>
Cc: dm-devel@redhat.com
Cc: linux-fscrypt@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Milan Broz <gmazyland@gmail.com>

Ard Biesheuvel (4):
  crypto: essiv - create wrapper template for ESSIV generation
  fs: crypto: invoke crypto API for ESSIV handling
  md: dm-crypt: infer ESSIV block cipher from cipher string directly
  md: dm-crypt: switch to ESSIV crypto API template

 crypto/Kconfig              |   4 +
 crypto/Makefile             |   1 +
 crypto/essiv.c              | 624 ++++++++++++++++++++
 drivers/md/Kconfig          |   1 +
 drivers/md/dm-crypt.c       | 237 ++------
 fs/crypto/Kconfig           |   1 +
 fs/crypto/crypto.c          |   5 -
 fs/crypto/fscrypt_private.h |   9 -
 fs/crypto/keyinfo.c         |  88 +--
 9 files changed, 675 insertions(+), 295 deletions(-)
 create mode 100644 crypto/essiv.c

-- 
2.17.1

