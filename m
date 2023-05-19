Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2B7709624
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 May 2023 13:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjESLSJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 19 May 2023 07:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbjESLSG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 19 May 2023 07:18:06 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E07710C3
        for <linux-fscrypt@vger.kernel.org>; Fri, 19 May 2023 04:18:04 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f42769a0c1so31113645e9.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 19 May 2023 04:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684495083; x=1687087083;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YmxaI1amCfTksu6ynk2557PwK0HJxrBQmYIx/Pz5hBs=;
        b=dp+mR0vkFQD+NRcVbVyj7ZlxJiY8tXKz6Dxjt02kU/9woIUxxNMg5SvP4xJ9eDYE2l
         hEJnfKK8BrITZUJm9ghCyPg0Je/wA7ZgsYMJwVI4lH3jXGvqlwkDJtDwfhLanlOsT7wH
         hQNPeCWF3wvvAZcvRLj33th7gYZ9PBshaM63xjIgYDJS4JRwCX0aFRvKXP3BWylWimpe
         32aKHm6KkPEtxXep1GltN/NdkgyiCPA4l7PN1GNXnXbpDZBBR5hr4EY5Y5zYuEDAHe2L
         02Hos4KJ6tjKqeoN5tOyzagtXmnXAX0KjFhaRoSVPjIKvYuO1hoBO+IbePE5pb7+tpSc
         zBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684495083; x=1687087083;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YmxaI1amCfTksu6ynk2557PwK0HJxrBQmYIx/Pz5hBs=;
        b=OIMLEwfaSXkwYaOQe5wqy/K7p7ROqZwQCTbqbkBSTsuDgJTIStHKU1frlTsGnmmY4P
         HzI3kFVIGCv++p4iuRENmLMSW0YRWso6WbKqcuMnCjQs2uhRJI1zrcQ7/4NC3IUIGWcH
         MuRcrY456msXkFj6yoc848uiFNrLpYGOcHzNNwNXMb3Yd4C1nGZWoGpJxcjrA8ONQM83
         4zyFdL4HSHU4b27E3eX0f64v0YFR2eQMNcbUR5dT/+kq2YbmizlJ+mliiEwC+4gnr8wI
         08VWvQgBw0lp+D9a1pR2RzVXmWVQa+o0ocPqLW8MLEkaxgHeVCVCl0eunegfAe1VHswu
         09Ug==
X-Gm-Message-State: AC+VfDysmOUftuslIWW3aMqXJYBtueoOqF30KPJe7JwQh2wEsS5h+Fre
        q/Ivjfz6vEtoFQgWL+WZAUGzyAgK21K1q/IjxQ4eC3lKzBsczQ==
X-Google-Smtp-Source: ACHHUZ4GcdKjctEWmkMJD/Q5ZDCusH7zrjV+w4c4EgP8GDbM+BMa7NNuPpP4cOMUW2oAUk/kOHHzW6hqw5zKR98kQX0=
X-Received: by 2002:a17:907:1b12:b0:8b8:c06e:52d8 with SMTP id
 mp18-20020a1709071b1200b008b8c06e52d8mr1298232ejc.36.1684495062361; Fri, 19
 May 2023 04:17:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:7dab:b0:94f:7d03:8e8b with HTTP; Fri, 19 May 2023
 04:17:41 -0700 (PDT)
Reply-To: ninacoulibaly03@myself.com
From:   nina coulibaly <ninacoulibaly199@gmail.com>
Date:   Fri, 19 May 2023 04:17:41 -0700
Message-ID: <CAM7Z2JAd00KW6b=O8M27vwRnsJ1w3AmDO5tP+gSmzkaHvk6=CA@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Dear,

Please grant me permission to share a very crucial discussion with
you. I am looking forward to hearing from you at your earliest
convenience.

Mrs. Nina Coulibal
